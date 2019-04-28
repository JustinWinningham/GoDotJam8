extends Control

var thePlayer
var timeAlive = 0

func _ready():
	thePlayer = get_parent().get_parent().get_parent().get_node("Player_v2")
	pass # Replace with function body.


func _process(delta):
	timeAlive += delta
	$GripBar.value = thePlayer.walljump_window
	$FPSLabel.text = String("FPS: %s" % Engine.get_frames_per_second())
	$FallSpeedLabel.text = String("Fall Speed: %s" % int((thePlayer.motion.y)))
	if thePlayer.flump_window > 0:
		$FlumpWindowLabel.text = "Can Jump!"
	else:
		$FlumpWindowLabel.text = "No Jump!"
	#$FlumpWindowLabel.text = String(thePlayer.flump_window)
	$GravityLabel.value = lerp($GravityLabel.value, thePlayer.BlackHoleForce * 5, 0.1)
	$TimeAlive.text = "Time survived: %s" % stepify(timeAlive, 0.01)
	
	$YPOS.text = "Y Position: %s" % stepify(thePlayer.position.y, 0.1)
	
	pass


#	if BlackHole != null:
#		var intensity = BlackHole.getGravIntensity(thePlayer.position.y)
#		var cur_y = $CanvasLayer/UI/DANGER.position.y
#		if !intensity <= BlackHole.farGravPull and intensity < BlackHole.closeGravPull:
#			cur_y = lerp(cur_y, 1000, 0.05) # Go into view
#		else:
#			cur_y = lerp(cur_y, 1200, 0.05) # Go out of view
#		$CanvasLayer/UI/DANGER.position.y = cur_y