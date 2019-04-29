extends StaticBody2D

var thePlayer
var endOfLevelDelay
export (String) var nextLevel = ""
var hasPlayed = false

func _ready():
	endOfLevelDelay = 20
	if get_parent().has_node("Player"):
		thePlayer = get_parent().get_node("Player")
	else:
		thePlayer = null

func _process(delta):
	if thePlayer != null:
		if $Area2D.overlaps_body(thePlayer):
			if !$FinalGG.is_playing() and !hasPlayed:
				$FinalGG.play()
				hasPlayed = true
	pass
