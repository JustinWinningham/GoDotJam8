extends Area2D

export(float) var goneGravPull = 0.5
export(float) var veryFarGravPull = 1
export(float) var farGravPull = 2
export(float) var midGravPull = 5
export(float) var closeGravPull = 10

#export(float) var goneGrav = -1000
export(float) var veryFarGrav = -400
export(float) var farGrav = 0
export(float) var midGrav = 300
export(float) var closeGrav = 700

func _ready():
	pass # Replace with function body.


func _process(delta):
	var bodies = get_overlapping_bodies()
	for bod in bodies:
		if bod == get_parent().get_node("Player"):
			# Level failure actions here
			if get_parent().name == "Level_EndlessMode" or get_parent().name == "Level_EndlessModeHardcore":
				$"/root/GLOBAL".num_deaths += 1
			get_tree().reload_current_scene()
		else:
			bod.free()
		pass

func getGravIntensity(ypos):
	if ypos > closeGrav:
		return closeGravPull
	elif ypos > midGrav:
		return midGravPull
	elif ypos > farGrav:
		return farGravPull
	elif ypos > veryFarGrav:
		return veryFarGravPull
	else:
		return goneGravPull