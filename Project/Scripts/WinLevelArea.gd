extends StaticBody2D

var thePlayer
var endOfLevelDelay
export (String) var nextLevel = ""

func _ready():
	endOfLevelDelay = 20
	if get_parent().has_node("Player"):
		thePlayer = get_parent().get_node("Player")
	else:
		thePlayer = null

func _process(delta):
	if thePlayer != null:
		if $Area2D.overlaps_body(thePlayer):
			if nextLevel != "":
				if endOfLevelDelay == 0:
					get_tree().change_scene(nextLevel)
				else:
					endOfLevelDelay -= 1
					#play any sounds or fx here
	pass
