extends RigidBody2D


export(int) var asteroid_weight = 2
# export(bool) var override_random_rot = true
export(Vector2) var initial_velocity = Vector2()
export(int) var BH_Intensity_Curve = 1000
export(bool) var isGiant = false

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
	if get_parent().get_parent().has_node("BlackHole"):
		var BH = get_parent().get_parent().get_node("BlackHole")
		var gravY = BH.getGravIntensity(position.y)
		var impulser = (BH.position - position) / BH_Intensity_Curve
		impulser.y = gravY
		#apply_central_impulse((BH.position - position) / BH_Intensity_Curve)
		if !isGiant:
			apply_central_impulse(impulser)
		else:
			apply_central_impulse(impulser.normalize())
	pass

func slam_jam(loc, force):
	if !loc or !force:
		#print("bad values passed to slam_jam")
		#print("Slamloc: %s, Slamforce: %s" % [loc, force])
		pass
	else:
		if !isGiant:
			push_force = (force - self.linear_velocity) / state_weight
			std_offset = position - loc # Don't change this, feels perfect right now
		else:
			push_force = (force - self.linear_velocity) / state_weight
			std_offset = position - loc
		
# Called every collision
func _integrate_forces(state):
	if push_force.x < 100 and push_force.y < 100:
		if !isGiant:
			apply_impulse(std_offset, push_force / 2)
		else:
			apply_impulse(std_offset, push_force / 4)
		pass
	if angular_velocity > 1:
		angular_velocity = 0 # prevent asteroids from spinning at mach 11
	#print("Force: (%s, %s)" % [push_force.x, push_force.y])  
	std_offset = Vector2(0,0)
	push_force = Vector2(0,0)