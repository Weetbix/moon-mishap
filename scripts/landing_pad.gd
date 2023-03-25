extends Area2D
class_name LandingPad

@onready var landingTimer: Timer = $LandingTimer
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var difficultyText: RichTextLabel = $DifficultyText

var difficulty : float
signal did_land(difficulty)

# Called when the node enters the scene tree for the first time.
func _ready():
	difficultyText.text = "x%.1f" % difficulty

func _on_area_entered(body:Node2D):
	landingTimer.start()

func _on_area_exited(body:Node2D):
	landingTimer.stop()

func _on_landing_timer_timeout():
	did_land.emit(1.0)
