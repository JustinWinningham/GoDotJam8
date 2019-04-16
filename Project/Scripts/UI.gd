extends Control

var thePlayer

func _ready():
	thePlayer = get_parent().get_parent().get_parent().get_node("Player")
	pass # Replace with function body.

func _process(delta):
	$GripBar.value = thePlayer.walljump_window
	$FPSLabel.text = String(Engine.get_frames_per_second())
	$FallSpeedLabel.text = String(int((thePlayer.motion.y)))
	$FlumpWindowLabel.text = String(thePlayer.flump_window)
	$GravityLabel.text = String(thePlayer.yy)
	pass
