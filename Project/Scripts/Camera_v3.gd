extends Camera2D

var thePlayer
var BlackHole

# TODO - Change these to follow the black hole +/- offset
export(int) var dangerFadeTop = -500 # Don't set to above 0 
export(int) var dangerFadeBot = 300 # Dont set above 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	thePlayer = get_parent().get_node("Player_v2")
	if get_parent().has_node("BlackHole_v2"):
		BlackHole = get_parent().get_node("BlackHole_v2")
	else:
		BlackHole = null
	pass # Replace with function body.

func _process(delta):
	position.y = thePlayer.position.y # add floaty offset?
	
	if BlackHole != null:
		var cur_y = $CanvasLayer/UI_v2/DANGER.position.y
		if thePlayer.position.y < dangerFadeBot and thePlayer.position.y > dangerFadeTop:
			cur_y = lerp(cur_y, 1000, 0.05) # TODO - Change this to follow the black hole properly
		else:
			cur_y = lerp(cur_y, 1200, 0.05)
		$CanvasLayer/UI_v2/DANGER.position.y = cur_y