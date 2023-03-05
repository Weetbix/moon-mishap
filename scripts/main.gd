extends Node2D

@onready var ui: UI = $UI
@onready var terrain: Terrain = $Terrain	
@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.fuel_changed.connect(ui.updateFuel)
	player.oxygen_changed.connect(ui.updateOxygen)