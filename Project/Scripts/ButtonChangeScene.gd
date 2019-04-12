extends Button


export(String) var scenePath

func _pressed():
	get_tree().change_scene(scenePath)
	print(scenePath)