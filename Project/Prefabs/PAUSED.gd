extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var paused = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("PAUSE"):
		if paused:
			get_tree().paused = false
			paused = false
			visible = false
		else:
			get_tree().paused = true
			paused = true
			visible = true
