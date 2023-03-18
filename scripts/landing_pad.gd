extends Area2D
class_name LandingPad

@onready var landingTimer: Timer = $LandingTimer
@onready var collisionShape: CollisionShape2D = $CollisionShape2D

var difficulty : float
signal did_land(difficulty)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(body:Node2D):
	landingTimer.start()

func _on_area_exited(body:Node2D):
	landingTimer.stop()

func _on_landing_timer_timeout():
	did_land.emit(1.0)
