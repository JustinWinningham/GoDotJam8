extends RigidBody2D


export(int) var asteroid_weight = 10
export(bool) var override_random_rot = true
export(Vector2) var initial_velocity = Vector2()
export(int) var BH_Intensity_Curve = 2000

var std_offset = Vector2()
var push_force = Vector2()
var state_weight = Vector2(asteroid_weight, asteroid_weight)
# Called when the node enters the scene tree for the first time.
func _ready():
	std_offset = Vector2(0.0, 0.0)
	push_force = Vector2(0.0, 0.0)
	mass = 1
	apply_central_impulse(initial_velocity)
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var BH = get_parent().get_parent().get_node("BlackHole")
	if BH != null:
		print("Suction!")
		apply_central_impulse((BH.position - position) / BH_Intensity_Curve) 
	pass

func slam_jam(loc, force):
	if !loc or !force:
		print("bad values passed to slam_jam")
		#print("Slamloc: %s, Slamforce: %s" % [loc, force])
	else:
		push_force = (force - self.linear_velocity) / state_weight
		std_offset = position - loc # Don't change this, feels perfect right now

# Called every collision
func _integrate_forces(state):
	if push_force.x < 100 and push_force.y < 100:
		apply_impulse(std_offset, push_force)
	#print("Force: (%s, %s)" % [push_force.x, push_force.y])  
	std_offset = Vector2(0,0)
	push_force = Vector2(0,0)