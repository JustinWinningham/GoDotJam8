extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Vector2) var maxCameraZoom = Vector2(2.0, 2.0)
export(Vector2) var minCameraZoom = Vector2(0.5, 0.5)
export(Vector2) var cameraIncrements = Vector2(0.1, 0.1)
export(Vector2) var defaultZoom = Vector2(1.0, 1.0)

export(float) var zoomFrameDelta = 0.05
var currentZoomTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	set_zoom(Vector2(100, 100))
	currentZoomTarget = defaultZoom
	pass # Replace with function body.


func _process(delta):
	var currentZoom = get_zoom()
	if Input.is_action_pressed("CameraZoomIn") and currentZoomTarget > minCameraZoom:
		currentZoomTarget -= cameraIncrements
	elif Input.is_action_pressed("CameraZoomOut") and currentZoomTarget < maxCameraZoom:
		currentZoomTarget += cameraIncrements
	elif Input.is_action_just_pressed("CameraReset") and currentZoomTarget != defaultZoom:
		currentZoomTarget = defaultZoom
	if Input.is_action_pressed("Debug"):
		print("Zoom: %s, Target: %s" % [currentZoom, currentZoomTarget])
	
	var frameTargetX = lerp(currentZoom.x, currentZoomTarget.x, zoomFrameDelta)
	var frameTargetY = lerp(currentZoom.y, currentZoomTarget.y, zoomFrameDelta)
	var vector2Target = Vector2(frameTargetX, frameTargetY)
	set_zoom(vector2Target)