extends Node



var max_height_in_endless
var max_time_in_endless
var num_walljumps
var num_jumps
var num_deaths
##
### Called when the node enters the scene tree for the first time.
func _ready():
	max_time_in_endless = 0
	max_height_in_endless = 0
	num_walljumps = 0
	num_jumps = 0
	num_deaths = 0
	pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
##
##func save(content):
##	var file = File.new()
##	file.open("user://save_game.dat", File.WRITE)
##
##func loadSave():
##	var file = File.new()
##	file.open("user://save_game.dat", File.READ)
##	var content = file.get_as_text()
##	return content
