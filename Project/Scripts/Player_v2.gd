extends KinematicBody2D

const UP = Vector2(0, -1) # set what direction is UP for move_and_slide
const GRAVITY = 10 # for levels without black hole
const MAX_SPEED = 300 # terminal velocity
const ACCELERATION = 20 # left/right movement acceleration
const JUMP_FORCE = -500 # Max jump force
const WALLJUMP_WINDOW_MAX = 60 # Grip reset value
const FLUMP_WINDOW_MAX = 10 # Flump reset value

var walljump_window = WALLJUMP_WINDOW_MAX # tracks if player can walljump
var flump_window = FLUMP_WINDOW_MAX # tracks if player can jump (for a few frames after leaving ground)
var was_on_wall_last_frame = false # tracks if we were wallhanging last frame - for input calculation
var was_airborne_last_frame = true # treacks if we were airborne last frame - for physics calculation

var can_attach = false # used to determine if we should slave player movement to whatever we are standing on

var motion = Vector2() # track our frame motion
var last_frame_motion = Vector2(1.0, 1.0) # tracks what our motion was in the last frame
var airMotion = Vector2() # used in flump calulations
var playerHasControl = true # for suspending player control for various reasons
var is_touching_asteroid = false # track is the player is touching an asteroid
var BlackHoleForce = 0 # Track the gravity force of the black hole, for adding to Motion

func _physics_process(delta):
	can_attach = false
	
	########### Gravity Handling ###########
	
	if !get_parent().has_node("BlackHole_v2"): # determine if we need static gravity
		print("No Black Hole") # Debug Line
		if motion.y < MAX_SPEED: # Check for terminal velocity
			motion.y += GRAVITY
	else:
		if motion.y < MAX_SPEED: # Check for terminal velocity
			BlackHoleForce = get_parent().get_node("BlackHole_v2").getGravIntensity(position.y)
			motion.y += BlackHoleForce + GRAVITY # Add black hole force
	var friction = false # assume there is no friction until we can prove otherwise
	
	########### Right Movement Handling ###########
	
	if Input.is_action_pressed("ui_right"):
		$Sprite.set_speed_scale(1) # reset our run animation speed to default
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED) # Add movement force
		if motion.x < 0: # If we are moving left, but pressing right, Skid.
			$Sprite.play("skid")
		elif motion.x < MAX_SPEED: # If we are moving right, and pressing right, flip the sprite right, and play Run animation
			$Sprite.flip_h = false
			$Sprite.play("run")
		else: # If we are at max speed, play Sprint animation
			$Sprite.play("sprint")
	
	########### Left Movement Handling ###########
	
	elif Input.is_action_pressed("ui_left"):
		$Sprite.set_speed_scale(1) # reset our run animation speed to default
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED) # Add movement force
		if motion.x > 0:
			$Sprite.play("skid") # If we are moving right, but pressing left, Skid.
		elif motion.x > -MAX_SPEED:
			$Sprite.flip_h = true # If we are moving left, and pressing left, flip the sprite left, and play Run animation
			$Sprite.play("run")
		else:
			$Sprite.play("sprint")
	
	########### Non-Input Movement Handling ###########
	
	else:
		friction = true # enable non-motion friction
		
		##### Walk Animation Handling #####
		
		if motion.x < 70 and motion.x > -70: # If the player is moving slowly, slow the run scale to half (walking)
			$Sprite.set_speed_scale(0.5)
			if motion.x < 20 and motion.x > -20: # again, even slower walking speed check
				$Sprite.set_speed_scale(0.2)
		
		##### Idle Animation Handling #####
		
		if motion.x < 5 and motion.x > -5: # If player is barely moving, force idle
			$Sprite.play("idle")
			$Sprite.set_speed_scale(1)
			motion.x = 0
			can_attach = true # set attachable to true
		else: #TODO may need to add a handler to continue fall animation when airborne
			$Sprite.play("skid") # if player is moving quickly, but not inpuiting anything, Skid
		
		##### Floor handling #####
		
	if is_on_floor():
		was_on_wall_last_frame = false # Since we are on the floor, we are no longer on the wall
		was_airborne_last_frame = false # Since we are on the floor, we are no longer in the air
		walljump_window = min(walljump_window + 2, WALLJUMP_WINDOW_MAX)
		flump_window = FLUMP_WINDOW_MAX # Reset the flump window
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2) # apply friction
	
	##### Wall handling #####
	
	elif is_on_wall():
		flump_window = 0 # Reset our flump window
		$Sprite.play("hang") # We are on the wall, so set state and animation to say so
		was_on_wall_last_frame = true
		if walljump_window > WALLJUMP_WINDOW_MAX / 2: # We only want the slide to occur if we are above 50% grip
			motion.y = clamp(motion.y, -10, 10) # Slow the player when they hang on the wall
		
		# if we jumped, pressed left/right, and are still within the walljump window - allow a walljump
		
		if Input.is_action_just_pressed("Jump") and Input.is_action_pressed("ui_left") and walljump_window > 0:
			$"/root/GLOBAL".num_walljumps += 1
			$Sprite.flip_h = false
			motion.x = MAX_SPEED
			motion.y = JUMP_FORCE
#				walljump_window -= 20 # Uncomment if we want to have walljumps reduce grip
		
		elif Input.is_action_just_pressed("Jump") and Input.is_action_pressed("ui_right") and walljump_window > 0:
			$"/root/GLOBAL".num_walljumps += 1
			$Sprite.flip_h = true
			motion.x = -MAX_SPEED
			motion.y = JUMP_FORCE
#				walljump_window -= 20 # Uncomment if we want to have walljumps reduce grip
		else:
			walljump_window -= 1 # Since we are hanging on the wall, reduce the walljump window
		
	elif was_on_wall_last_frame:
		walljump_window -= 1 # Not uncommon for player to 'jitter' on and off the wall, so we allow an extra frame to count as 'on the wall'
		was_on_wall_last_frame = false # Since we are no longer on the wall, set the state to false
		
	# If we are not on a floor, hanging on a wall (or on a wall the last frame)...
	# Basically meaning that we are airborne
	else:
		if motion.y < 0: # If we are rising
			$Sprite.play("jump")
			pass
		else: # If we are falling
			$Sprite.play("fall")
			pass
		can_attach = false # can't attach if we are not meeting any of these conditions
		was_airborne_last_frame = true
		flump_window -= 1 # keep ticking our flump window
		motion.x = lerp(motion.x, 0, 0.05) # airborne friction
		airMotion = motion # Set our airmotion state, used by other scripts
	
	###### Attachment Handling ######
	
	if can_attach:
		$Sprite.play("idle") # Player must be idling if attached
		var asteroids = get_tree().get_nodes_in_group("Asteroids")
		if asteroids:
			var nearest_asteroid = asteroids[0]
			for roid in asteroids:
				if roid.global_position.distance_to(self.position) < nearest_asteroid.global_position.distance_to(self.position):
					nearest_asteroid = roid
			motion = nearest_asteroid.get_linear_velocity()
#			motion.x = nearest_asteroid.velocity.x
#			motion.y = nearest_asteroid.velocity.y
		# This is where I would change the UP
	else:
		pass
	
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

