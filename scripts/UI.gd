extends Control
class_name UI

@onready var fuel_bar: Node2D = $Fuel/fuel_line
@onready var oxygen_bar: Node2D = $Oxygen/line
@onready var score: RichTextLabel = $Score/Score
@onready var mission: RichTextLabel = $Score/Mission
@onready var winBox: Node = $WinBox
@onready var failBox: Node = $FailBox
@onready var winBoxText: RichTextLabel = $WinBox/Text
@onready var failBoxText: RichTextLabel = $FailBox/Text

var winBox_text = "[center]
Congratulations PILOT 0435 you have successfully completed MISSION %s

Resource bonus recieved: %d

Eject to continue simulation
[/center]"

var failBox_text = "[center]
you have FAILED to complete MISSION %s 

Eject to RETRY
[/center]"

func updateScore(amount: int):
	score.text = "%08d" % amount

func updateScoreFromLevel(amount: int):
	winBoxText.text = winBox_text % [mission.text, amount]

func updateMission(number: int):
	mission.text = "%02d" % number
	failBoxText.text = failBox_text % number

func updateFuel(amount):
	fuel_bar.scale.x = amount / 100.0

func updateOxygen(amount):
	oxygen_bar.scale.x = amount / 100.0

func levelCompleted():
	winBox.visible = true

func levelFailed():
	failBox.visible = true

func levelStarted():
	winBox.visible = false
	failBox.visible = false
