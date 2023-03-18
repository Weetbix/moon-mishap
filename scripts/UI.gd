extends Control
class_name UI

@onready var fuel_bar: Node2D = $Fuel/fuel_line
@onready var oxygen_bar: Node2D = $Oxygen/line
@onready var score: RichTextLabel = $Score/Score
@onready var mission: RichTextLabel = $Score/Mission

func updateScore(amount: int):
	score.text = "%08d" % amount

func updateMission(number: int):
	mission.text = "%02d" % number

func updateFuel(amount):
	fuel_bar.scale.x = amount / 100.0

func updateOxygen(amount):
	oxygen_bar.scale.x = amount / 100.0