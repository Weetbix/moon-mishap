@tool
extends Node2D

var landing_pad = preload("res://scenes/landing_pad.tscn")

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
	print(position)
	var new_platform = landing_pad.instantiate()
	new_platform.add_to_group('platforms')
	new_platform.position = position
	self.add_child(new_platform)

func generate_level():
	delete_all_platforms()
	terrain.generate()

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain.platform_created.connect(place_platform)

	# Dont do a lot of stuff when running in the editor,
	# otherwise we have to connect all the nodes
	if not Engine.is_editor_hint():
		player.fuel_changed.connect(ui.updateFuel)
		player.oxygen_changed.connect(ui.updateOxygen)
		generate_level()
