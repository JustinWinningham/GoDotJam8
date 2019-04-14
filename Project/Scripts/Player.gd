extends KinematicBody2D


const UP = Vector2(0, -1) # set what direction is UP
const GRAVITY = 15 # this won't be a const in the future
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
var airMotion = Vector2()
var playerHasControl = true

func _physics_process(delta):
	can_attach = false
	motion.y += GRAVITY
	$Camera2D/UI/GripBar.set_value(walljump_window)
	$Camera2D/UI/FallSpeedLabel.text = String(motion.y / 10)
	$Camera2D/UI/SpeedLabel.text = String(motion.x)
	$Camera2D/UI/FlumpWindowLabel.text = String(flump_window)
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
		$Camera2D/UI/Label.text = "Grounded!"
		was_on_wall_last_frame = false
		walljump_window = min(walljump_window + 2, WALLJUMP_WINDOW_MAX)
		flump_window = FLUMP_WINDOW_MAX
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
			
	elif is_on_wall():
		flump_window = 0
		$Camera2D/UI/Label.text = "Walled!"
		was_on_wall_last_frame = true
		if walljump_window > WALLJUMP_WINDOW_MAX / 2:
			motion.y = clamp(motion.y, -10, 10)
			# Add particle effect here if we get that far!
		
		if Input.is_action_just_pressed("Jump") and Input.is_action_pressed("ui_left") and walljump_window > 0:
			print("WALLJUMP 1!")
			motion.x = MAX_SPEED
			motion.y = JUMP_FORCE
			walljump_window -= 20
		elif Input.is_action_just_pressed("Jump") and Input.is_action_pressed("ui_right") and walljump_window > 0:
			print("WALLJUMP 2!")
			motion.x = -MAX_SPEED
			motion.y = JUMP_FORCE
			walljump_window -= 20
		else:
			walljump_window -= 1
	elif was_on_wall_last_frame:
		walljump_window -=1
		was_on_wall_last_frame = false
	else:
		if motion.y < 0:
#			$Sprite.play("jump")
			pass
		else:
#			$Sprite.play("fall")
			pass
		$Camera2D/UI/Label.text = "Airborne!"
		can_attach = false
		was_airborne_last_frame = true
		flump_window -= 1
		motion.x = lerp(motion.x, 0, 0.05)
		airMotion = motion

	if can_attach:
		$Camera2D/UI/Label.text = "Attached!"
		$Sprite.play("idle")
		var asteroids = get_tree().get_nodes_in_group("Asteroids")
		var nearest_asteroid = asteroids[0]

		for roid in asteroids:
			if roid.global_position.distance_to(self.position) < nearest_asteroid.global_position.distance_to(self.position):
				nearest_asteroid = roid
		motion.x = nearest_asteroid.velocity.x
		motion.y = nearest_asteroid.velocity.y
		
	if flump_window > 0:
		if Input.is_action_just_pressed("Jump"):
			motion.y = JUMP_FORCE
			airMotion = motion
	
	motion = move_and_slide(motion, UP, true, 4, deg2rad(60), true)