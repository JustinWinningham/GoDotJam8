extends Button

export(String) var scenePath

func _pressed():
	var player = AudioStreamPlayer.new()
	player.stream = load("res://Audio/Retro_8-Bit_Game-Interface_UI_04.wav")
	player.play()
	get_tree().change_scene(scenePath)