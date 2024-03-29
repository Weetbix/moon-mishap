extends RigidBody2D
class_name Player

@onready var flame: Node2D = $flame
@onready var particles: GPUParticles2D = $particles

const ROTATE_SPEED = 30
const THRUST_AMOUNT = 40

const FUEL_INITIAL_VALUE = 100
const OXYGEN_INITIAL_VALUE = 100
const FUEL_REDUCTION_PER_FRAME : float = 0.1
const OXYGEN_REDUCTION_PER_FRAME : float = 0.03

var fuel = FUEL_INITIAL_VALUE
var oxygen = OXYGEN_INITIAL_VALUE

signal fuel_changed(amount)
signal oxygen_changed(amount)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_width = ProjectSettings.get_setting('display/window/size/viewport_width')

func emit_current_resources():
	oxygen_changed.emit(oxygen)
	fuel_changed.emit(fuel)

func reset_resources():
	fuel = FUEL_INITIAL_VALUE
	oxygen = OXYGEN_INITIAL_VALUE
	emit_current_resources()

func _ready():
	emit_current_resources()

func _physics_process(_delta):
	oxygen = max(0, oxygen - OXYGEN_REDUCTION_PER_FRAME)
	oxygen_changed.emit(oxygen)

	# Rotation
	var rotate_amount = Input.get_action_strength("rotate-left") - Input.get_action_strength("rotate-right")
	apply_torque(-rotate_amount * ROTATE_SPEED)

	flame.visible = false
	particles.emitting = false;

	# Thrust
	if fuel > 0:
		var thruster_amount = Input.get_action_strength("thruster")

		if thruster_amount > 0:
			var thrust = Vector2(0, -THRUST_AMOUNT) * thruster_amount
			apply_force(thrust.rotated(rotation))
			fuel -= FUEL_REDUCTION_PER_FRAME
			fuel_changed.emit(fuel)
			flame.visible = true
			particles.emitting = true;

func _integrate_forces(state):
	var xform = state.get_transform()

	# Warp when off screen
	if xform.origin.x > screen_width:
		xform.origin.x = 0
	elif xform.origin.x < 0:
		xform.origin.x = screen_width

	state.set_transform(xform)