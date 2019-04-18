extends Control

func _ready():
	print("MAIN MENU READY!")
	$numDeaths.text = "Total Deaths: %s" % $"/root/GLOBAL".num_deaths
	$numJumps.text = "Total Jumps: %s" % $"/root/GLOBAL".num_jumps
	$numWallJumps.text = "Total Wall Jumps: %s" % $"/root/GLOBAL".num_walljumps
	$max_endless_height.text = "Best Height - Endless Mode: %s" % stepify($"/root/GLOBAL".max_height_in_endless, 0.1)
	$max_endless_time.text = "Best Time - Endless Mode: %s" % stepify($"/root/GLOBAL".max_time_in_endless, 0.01)