extends Area2D
class_name LandingPad

@onready var landingTimer: Timer = $LandingTimer
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var difficultyText: RichTextLabel = $DifficultyText

var difficulty : float
signal did_land(difficulty: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	difficultyText.text = "x%.1f" % difficulty

func _on_area_entered(_area: Area2D) -> void:
	landingTimer.start()

func _on_area_exited(_area: Area2D) -> void:
	landingTimer.stop()

func _on_landing_timer_timeout() -> void:
	did_land.emit(1.0)
