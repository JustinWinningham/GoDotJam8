extends Button

export(String) var scenePath
export(String) var FXPath
export(float) var FXVolume = 1
var thePlayer
var delay = 10

func _ready():
	thePlayer = AudioStreamPlayer2D.new()
	self.add_child(thePlayer)
	thePlayer.volume_db = FXVolume
	thePlayer.stream = load(FXPath)
	pass

func _pressed():
	thePlayer.play()
	get_tree().change_scene(scenePath)
	if get_tree().paused:
		get_tree().paused = false

