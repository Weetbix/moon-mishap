extends Node2D

var landing_pad = preload("res://scenes/landing_pad.tscn")

@onready var ui: UI = $UI
@onready var terrain: Terrain = $Terrain	
@onready var player: Player = $Player

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

# Called when the node enters the scene tree for the first time.
func _ready():
	player.fuel_changed.connect(ui.updateFuel)
	player.oxygen_changed.connect(ui.updateOxygen)
	terrain.platform_created.connect(place_platform)
	terrain.generate()
