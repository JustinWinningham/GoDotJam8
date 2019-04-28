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

var deathScreening = false
var holding = 600
var hasPlayed = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	if !deathScreening:
		var bodies = get_overlapping_bodies()
		position.y -= 1
		for bod in bodies:
			if bod == get_parent().get_node("Player"):
				# Level failure actions here
				if get_parent().name == "Level_EndlessMode" or get_parent().name == "Level_EndlessModeHardcore":
					$"/root/GLOBAL".num_deaths += 1
				get_tree().paused = true
				deathScreening = true
			else:
				if bod.name != "TileMap":
					print("Black hole ate object: %s" % bod.name)
					bod.free()
			pass
	else:
		if !$DeadAudio.is_playing() and !hasPlayed:
			$DeadAudio.play()
			hasPlayed = true
		if $GG.position.y > -200:
			$GG.position.y = lerp($GG.position.y, -201, 0.04)
			if $GG.position.y < -199:
				$GG.position.y = -201
		else:
			holding -= 1
		if holding == 0:
			get_tree().paused = false
			get_tree().reload_current_scene() 


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