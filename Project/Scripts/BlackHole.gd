extends Area2D

export(int) var goneGravPull = 1
export(int) var veryFarGravPull = 2
export(int) var farGravPull = 10
export(int) var midGravPull = 20
export(int) var closeGravPull = 40

export(int) var goneGrav = 4000
export(int) var veryFarGrav = 2000
export(int) var farGrav = 1000
export(int) var midGrav = 400

func _ready():
	pass # Replace with function body.


func _process(delta):
		pass

func getGravIntensity(ypos):
	if abs(ypos - position.y) > goneGrav:
		return goneGravPull
	elif abs(ypos - position.y) > veryFarGrav:
		return veryFarGravPull
	elif abs(ypos - position.y) > farGrav:
		return farGravPull
	elif abs(ypos - position.y) > midGrav:
		return midGravPull
	else:
		return closeGravPull