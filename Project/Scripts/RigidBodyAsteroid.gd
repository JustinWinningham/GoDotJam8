extends RigidBody2D

export(float) var weightlessness
var external_force_last_frame = false
var external_force = Vector2(0.0, 0.0)
var external_offset = Vector2(0.0, 0.0)

func _ready():
	pass

func _physics_process(delta):
	if external_force_last_frame:
		external_force_last_frame = false
	else:
		print("External force detected!")
		external_force_last_frame = true
		process_external_force(external_force, external_offset)
		add_force(external_offset, external_force)
		external_force = Vector2(0.0, 0.0)
		external_offset = Vector2(0.0, 0.0)

func process_external_force(force, offset):
	external_force = force
	external_offset = offset