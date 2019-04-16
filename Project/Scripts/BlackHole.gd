extends Area2D

export(float) var goneGravPull = 0.5
export(float) var veryFarGravPull = 1
export(float) var farGravPull = 2
export(float) var midGravPull = 5
export(float) var closeGravPull = 10

#export(float) var goneGrav = 4000
#export(float) var veryFarGrav = 2000
#export(float) var farGrav = 1000
#export(float) var midGrav = 400
export(float) var goneGrav = -500
export(float) var veryFarGrav = 0
export(float) var farGrav = 400
export(float) var midGrav = 600
export(float) var closeGrav = 750

func _ready():
	pass # Replace with function body.


func _process(delta):
	var bodies = get_overlapping_bodies()
	for bod in bodies:
		if bod == get_parent().get_node("Player"):
			# Level failure actions here
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

#func getGravIntensity(ypos):
#	if abs(ypos - position.y) > goneGrav:
#		return goneGravPull
#	elif abs(ypos - position.y) > veryFarGrav:
#		return veryFarGravPull
#	elif abs(ypos - position.y) > farGrav:
#		return farGravPull
#	elif abs(ypos - position.y) > midGrav:
#		return midGravPull
#	else:
#		return closeGravPull