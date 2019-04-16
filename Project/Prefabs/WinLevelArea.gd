extends Area2D

var thePlayer
var endOfLevelDelay
export (NodePath) var nextLevel = ""

func _ready():
	endOfLevelDelay = 20
	if get_parent().get_parent().has_node("Player"):
		thePlayer = get_parent().get_parent().get_node("Player")
	else:
		thePlayer = null

func _process(delta):
	if thePlayer != null:
		if overlaps_body(thePlayer):
			print("Winner!")
			if nextLevel != "":
				if endOfLevelDelay == 0:
					get_tree().change_scene(nextLevel)
				else:
					endOfLevelDelay -= 1
					#play any sounds or fx here
	pass
