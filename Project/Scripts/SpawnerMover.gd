extends Node2D

var offset_goal
var thePlayer

func _ready():
	thePlayer = get_parent().get_parent().get_parent().get_node("Player")
	offset_goal = position.y

func _process(delta):
	position.y = thePlayer.position.y - offset_goal
