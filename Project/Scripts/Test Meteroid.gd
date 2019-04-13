extends KinematicBody2D

export(NodePath) var playerPath

var velocity = Vector2(0,10)
var thePlayer
#var velocity = Vector2(0.0, 1.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var rand_rot = rand_range(0, 360)
	rotate(rotation + rand_rot)
	thePlayer = get_node(playerPath)

#func _process(delta):
#	var contact_bodies = get_colliding_bodies()
#	for body in contact_bodies:
#		print(body)
		
func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal * 2)