extends Control
class_name UI

@onready var fuel_bar: Node2D = $Fuel/fuel_line
@onready var oxygen_bar: Node2D = $Oxygen/line

func updateFuel(amount):
	fuel_bar.scale.x = amount / 100.0

func updateOxygen(amount):
	oxygen_bar.scale.x = amount / 100.0