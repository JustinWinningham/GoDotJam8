extends Node2D

var offset_goal
var thePlayer

func _ready():
	if get_parent().get_parent().get_parent().has_node("Player"):
		thePlayer = get_parent().get_parent().get_parent().get_node("Player")
		offset_goal = position.y
	else:
		thePlayer = null
		offset_goal = 0

func _process(delta):
	if thePlayer != null:
		position.y = thePlayer.position.y - offset_goal