extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var thePlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	thePlayer = get_node("Player")
	pass # Replace with function body.

func _process(delta):
	position.y = thePlayer.position.y
	pass
