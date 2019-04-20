extends Node2D

onready var LrgAsteroidPacked = preload("res://Prefabs/Asteroids/BigAsteroidRigid.tscn")
onready var MedAsteroidPacked = preload("res://Prefabs/Asteroids/MedAsteroidRigid.tscn")
onready var SmlAsteroidPacked = preload("res://Prefabs/Asteroids/SmlAsteroidRigid.tscn")

var LrgAsteroidPrev = Vector2()

var TSpawners
var RSpawners
var LSpawners

var numTSpawners
var numRSpawners
var numLSpawners

export(int) var tickerMax = 10
export(int) var deleteTickerMax = 1000

export(int) var rxMax = 400
export(int) var ryMax = 100
export(bool) var hardMode = false

var ticker
var delTicker
var vertical_offset

func _ready():
	TSpawners = $Spawners_Top.get_children()
	RSpawners = $Spawners_Right.get_children()
	LSpawners = $Spawners_Left.get_children()
	
	numTSpawners = $Spawners_Top.get_child_count()
	numRSpawners = $Spawners_Right.get_child_count()
	numLSpawners = $Spawners_Left.get_child_count()
	
	ticker = tickerMax
	delTicker = deleteTickerMax

func _process(delta):

			
	delTicker -= 1
	ticker -= 1
	if delTicker == 0:
		delTicker = deleteTickerMax # Reset the ticker
		var disable_side = get_child(randi() % 3)
		if disable_side.get_child_count() != 0:
			var disable_digit = randi() % disable_side.get_child_count()
			disable_side.get_child(disable_digit).free()
			updateChildCounts()
			print("Deleting: Sizes - %s, %s, %s" % [numTSpawners, numRSpawners, numLSpawners ])
		#updateChildCounts()
	if ticker == 0:
		ticker = tickerMax
		var side = get_child(randi() % 3)
		if side.get_child_count() != 0:
			var pick = side.get_child(randi() % side.get_child_count())
			SpawnAsteroid(side, pick, randi() % 3)
	
	
func SpawnAsteroid(side, pick, size):
	var Asteroid
	if size == 0:
		if hardMode:
			Asteroid = MedAsteroidPacked.instance()
		else:
			Asteroid = LrgAsteroidPacked.instance()
	elif size == 1:
		Asteroid = MedAsteroidPacked.instance()
	else:
		Asteroid = SmlAsteroidPacked.instance()
		
	Asteroid.position = pick.position
	var rx
	var ry
	var xneg = 1
	var yneg = 1
	if randi()%2 == 0:
		xneg = -1
	if randi()%2 == 1:
		yneg = -1
	
	if side == $Spawners_Top:
		rx = 0
		#rx = (randi() % rxMax) * xneg
		ry = (randi() % ryMax) * yneg
	elif side == $Spawners_Right:
		rx = (randi() % rxMax) * -1
		ry = (randi() % ryMax) * yneg
	else:
		rx = (randi() % rxMax)
		ry = (randi() % ryMax) * yneg
	Asteroid.initial_velocity = Vector2(rx, ry)
	
	get_parent().get_node("Asteroids").add_child(Asteroid)
	

func updateChildCounts():
	numTSpawners = $Spawners_Top.get_child_count()
	numRSpawners = $Spawners_Right.get_child_count()
	numLSpawners = $Spawners_Left.get_child_count()
	pass