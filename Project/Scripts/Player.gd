extends KinematicBody2D

const UP = Vector2(0, -1) # set what direction is UP
const GRAVITY = 20 # this won't be a const in the future
const SPEED = 200
const JUMP_FORCE = -500
const WALLJUMP_WINDOW_MAX = 60

var walljump_window = WALLJUMP_WINDOW_MAX
var was_on_wall_last_frame = false

var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
	else:
		motion.x = 0
	
	if is_on_floor():
		was_on_wall_last_frame = false
		walljump_window = WALLJUMP_WINDOW_MAX
		if Input.is_action_just_pressed("Jump"):
			motion.y = JUMP_FORCE
	elif is_on_wall():
#		if !was_on_wall_last_frame:
#			motion.y /= 2
		was_on_wall_last_frame = true
		if walljump_window > WALLJUMP_WINDOW_MAX / 2:
			motion.y = clamp(motion.y, -10, 10)
			# Add particle effect here if we get that far!
		
		if Input.is_action_just_pressed("Jump") and Input.is_action_pressed("ui_left") and walljump_window > 0:
			print("WALLJUMP 1!")
			motion.x = SPEED
			motion.y = JUMP_FORCE
			walljump_window = 0
		elif Input.is_action_just_pressed("Jump") and Input.is_action_pressed("ui_right") and walljump_window > 0:
			print("WALLJUMP 2!")
			motion.x = -SPEED
			motion.y = JUMP_FORCE
			walljump_window = 0
		else:
			walljump_window -= 1
	elif was_on_wall_last_frame:
		walljump_window -=1
		was_on_wall_last_frame = false
	else:
		# Must be in midair
		if Input.is_action_pressed("Debug"):
			print("Midair?")
	
	motion = move_and_slide(motion, UP)
#	if Input.is_action_pressed("Debug"):
#		print("Window: %s || WallLastFrame: %s" % [walljump_window, was_on_wall_last_frame])
	pass