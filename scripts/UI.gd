extends Control

@onready var player: Player = $'../Player'
@onready var fuel_bar: Node2D = $Fuel/fuel_line
@onready var oxygen_bar: Node2D = $Oxygen/line

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	fuel_bar.scale.x = player.fuel / 100.0
	oxygen_bar.scale.x = player.oxygen / 100.0
