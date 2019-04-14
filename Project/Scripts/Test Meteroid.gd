extends KinematicBody2D

export(float) var weightlessness
export(bool) var override_random_rot = true

var velocity = Vector2(0.0,10.0)

#var velocity = Vector2(0.0, 1.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if !override_random_rot:
		var rand_rot = rand_range(0, 360)
		rotate(rotation + rand_rot)
	

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		print("Colliding")
		var col_norm = collision_info.normal * weightlessness
#		var col_norm = velocity.bounce(collision_info.normal) * weightlessness
#		print("col_norm---- X: %s Y: %s" % [col_norm.x, col_norm.y])
		if  col_norm.x > 1 or col_norm.y > 1 or col_norm.x < -1 or col_norm.y < -1: # must expand this to prevent micro-colisions
			velocity = velocity.bounce(collision_info.normal) * weightlessness
#	if $BlackHole:
#		print("Black hole exists on this level")