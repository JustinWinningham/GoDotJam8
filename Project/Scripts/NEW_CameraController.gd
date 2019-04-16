extends Camera2D

var thePlayer
var BlackHole
# Called when the node enters the scene tree for the first time.
func _ready():
	thePlayer = get_parent().get_node("Player")
	if get_parent().has_node("BlackHole"):
		BlackHole = get_parent().get_node("BlackHole")
	else:
		BlackHole = null
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y = thePlayer.position.y # add floaty offset?
	
	if BlackHole != null:
		var intensity = BlackHole.getGravIntensity(thePlayer.position.y)
		var cur_y = $CanvasLayer/UI/DANGER.position.y
		if !intensity <= BlackHole.farGravPull and intensity < BlackHole.closeGravPull:
			cur_y = lerp(cur_y, 1000, 0.05) # Go into view
		else:
			cur_y = lerp(cur_y, 1200, 0.05) # Go out of view
		$CanvasLayer/UI/DANGER.position.y = cur_y