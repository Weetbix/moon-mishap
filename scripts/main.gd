@tool
extends Node2D

var landing_pad = preload("res://scenes/landing_pad.tscn")
var score: int = 0
var mission: int = 1

@onready var ui: UI = $UI
@onready var terrain: Terrain = $Terrain	
@onready var player: Player = $Player

# Generate level when hitting the "do toggle" checkbox
@export var do_generate: bool = false:
	set(val):
		generate_level()

func delete_all_platforms():
	var platforms = get_tree().get_nodes_in_group('platforms')
	for platform in platforms:
		platform.queue_free()

func place_platform(position: Vector2, difficulty):
	var new_platform : LandingPad = landing_pad.instantiate()
	new_platform.add_to_group('platforms')
	new_platform.position = position
	new_platform.difficulty = difficulty
	new_platform.did_land.connect(did_land)
	self.add_child(new_platform)

func did_land(difficulty):
	print("DID LAND!")
	print(difficulty)

func generate_level():
	delete_all_platforms()
	terrain.generate()
	player.reset_resources()

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain.platform_created.connect(place_platform)

	# Dont do a lot of stuff when running in the editor,
	# otherwise we have to connect all the nodes
	if not Engine.is_editor_hint():
		player.fuel_changed.connect(ui.updateFuel)
		player.oxygen_changed.connect(ui.updateOxygen)
		ui.updateScore(score)
		ui.updateMission(mission)
		generate_level()

func _process(delta):
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("debug_generate_level"):
			generate_level()
