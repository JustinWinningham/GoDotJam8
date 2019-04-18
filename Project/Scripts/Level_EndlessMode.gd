extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bestTime
var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	time += delta
	if time > $"/root/GLOBAL".max_time_in_endless:
		$"/root/GLOBAL".max_time_in_endless = time
	var theHeight = abs($Player.position.y) + 900
	if theHeight > $"/root/GLOBAL".max_height_in_endless:
		$"/root/GLOBAL".max_height_in_endless = theHeight
