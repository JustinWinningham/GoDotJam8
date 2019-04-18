extends KinematicBody2D

const UP = Vector2(0, -1) # set what direction is UP
const GRAVITY = 10 # this won't be a const in the future
const MAX_SPEED = 300
const ACCELERATION = 20
const JUMP_FORCE = -600
const WALLJUMP_WINDOW_MAX = 60
const FLUMP_WINDOW_MAX = 10

var walljump_window = WALLJUMP_WINDOW_MAX
var flump_window = FLUMP_WINDOW_MAX
var was_on_wall_last_frame = false
var was_airborne_last_frame = true

var can_attach = false

var motion = Vector2()
var last_frame_motion = Vector2(1.0, 1.0)
var airMotion = Vector2()
var playerHasControl = true
var is_touching_asteroid = false
var yy = 0


func _physics_process(delta):
	can_attach = false
	if !get_parent().has_node("BlackHole"):
		print("No Black Hole")
		motion.y += GRAVITY
	else:
		yy = get_parent().get_node("BlackHole").getGravIntensity(position.y)
		motion.y += yy + GRAVITY
	var friction = false
	if Input.is_action_pressed("ui_right"):
		$Sprite.set_speed_scale(1)
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		if motion.x < 0:
			$Sprite.play("skid")
		elif motion.x < MAX_SPEED:
			$Sprite.flip_h = false
			$Sprite.play("run")
		else:
			$Sprite.play("sprint")
	elif Input.is_action_pressed("ui_left"):
		$Sprite.set_speed_scale(1)
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		if motion.x > 0:
			$Sprite.play("skid")
		elif motion.x > -MAX_SPEED:
			$Sprite.flip_h = true
			$Sprite.play("run")
		else:
			$Sprite.play("sprint")
	else:
		friction = true
		if motion.x < 70 and motion.x > -70:
			$Sprite.set_speed_scale(0.5)
			if motion.x < 20 and motion.x > - 20:
				$Sprite.set_speed_scale(0.2)
		if motion.x < 5 and motion.x > -5:
			$Sprite.play("idle")
			$Sprite.set_speed_scale(1)
			motion.x = 0
			can_attach = true
		else:
			$Sprite.play("skid")
			
	if is_on_floor():
		was_on_wall_last_frame = false
		was_airborne_last_frame = false
		walljump_window = min(walljump_window + 2, WALLJUMP_WINDOW_MAX)
		flump_window = FLUMP_WINDOW_MAX
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
			
	elif is_on_wall():
		flump_window = 0
		$Sprite.play("hang")
		was_on_wall_last_frame = true
		if walljump_window > WALLJUMP_WINDOW_MAX / 2:
			motion.y = clamp(motion.y, -10, 10)
			# Add particle effect here if we get that far!
		
		if Input.is_action_just_pressed("Jump") and Input.is_action_pressed("ui_left") and walljump_window > 0:
			$"/root/GLOBAL".num_walljumps += 1
			$Sprite.flip_h = false
			motion.x = MAX_SPEED
			motion.y = JUMP_FORCE
			#walljump_window -= 20
		elif Input.is_action_just_pressed("Jump") and Input.is_action_pressed("ui_right") and walljump_window > 0:
			$"/root/GLOBAL".num_walljumps += 1
			$Sprite.flip_h = true
			motion.x = -MAX_SPEED
			motion.y = JUMP_FORCE
			#walljump_window -= 20
		else:
			walljump_window -= 1
	elif was_on_wall_last_frame:
		walljump_window -=1
		was_on_wall_last_frame = false
	else:
		if motion.y < 0:
			$Sprite.play("jump")
			pass
		else:
			$Sprite.play("fall")
			pass
		can_attach = false
		was_airborne_last_frame = true
		flump_window -= 1
		motion.x = lerp(motion.x, 0, 0.05)
		airMotion = motion

	if can_attach:
		$Sprite.play("idle")
		var asteroids = get_tree().get_nodes_in_group("Asteroids")
		if asteroids:
			var nearest_asteroid = asteroids[0]
			for roid in asteroids:
				if roid.global_position.distance_to(self.position) < nearest_asteroid.global_position.distance_to(self.position):
					nearest_asteroid = roid
			motion = nearest_asteroid.get_linear_velocity()
#		motion.x = nearest_asteroid.velocity.x
#		motion.y = nearest_asteroid.velocity.y
		
	if flump_window > 0:
		if Input.is_action_just_pressed("Jump"):
			$"/root/GLOBAL".num_jumps += 1
			motion.y = JUMP_FORCE
			airMotion = motion
	
	
	motion = move_and_slide(motion, UP, true, 4, deg2rad(60), false)
	if position.x < 0:
		position.x = 0
		motion.x = 0
	if position.x > 1280:
		position.x = 1280
		motion.x = 0
	
	#########################################################################################################
	############# NO PLAYER MOTION CALCULATION BEYOND THIS POINT, ONLY ASTEROID MOTION HANDLING #############
	#########################################################################################################
	
	if get_slide_count() > 0:
		var wall_collider = get_slide_collision(0)
		if wall_collider:
			if was_airborne_last_frame or !was_on_wall_last_frame:
				#print(wall_collider.collider.name)
				talk_to_asteroids()
	if is_on_floor() and was_airborne_last_frame:
		#print("Just Landed")
		#talk_to_asteroids()
		pass
	elif is_on_wall() and was_airborne_last_frame and !was_on_wall_last_frame:
		#print("Just Hung")
		talk_to_asteroids()
	elif is_on_ceiling() and was_airborne_last_frame:
		#print("Just hit Ceiling")
		talk_to_asteroids()
	last_frame_motion = motion

func talk_to_asteroids():
	if is_touching_asteroid():
		var asteroids = get_parent().get_node("Asteroids").get_children()
		if asteroids:
			var nearest_asteroid = asteroids[0]
			for roid in asteroids:
				if roid.global_position.distance_to(self.position) < nearest_asteroid.global_position.distance_to(self.position):
					nearest_asteroid = roid
			if nearest_asteroid.has_method("slam_jam"):
				nearest_asteroid.slam_jam(position, last_frame_motion)
				
func is_touching_asteroid():
	for i in range(get_slide_count() - 1):
		var slide_collide = get_slide_collision(i)
		if slide_collide.collider.get_parent().name == "Asteroids":
			return true
	return false