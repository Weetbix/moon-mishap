extends RigidBody2D

@onready var flame: Node2D = $flame
@onready var particles: GPUParticles2D = $particles

const ROTATE_SPEED = 30
const THRUST_AMOUNT = 40

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_width = ProjectSettings.get_setting('display/window/size/viewport_width')

func warp_when_offscreen():
	if position.x > screen_width:
		position.x = 0
	elif position.x < 0:
		position.x = screen_width

func _physics_process(_delta):
	warp_when_offscreen()

	# Rotation
	var rotate_amount = Input.get_action_strength("rotate-left") - Input.get_action_strength("rotate-right")
	apply_torque(-rotate_amount * ROTATE_SPEED)

	# Thrust
	var thruster_amount = Input.get_action_strength("thruster")
	var thrust = Vector2(0, -THRUST_AMOUNT) * thruster_amount
	apply_force(thrust.rotated(rotation))

	if thruster_amount <= 0:
		flame.visible = false
		particles.emitting = false;
	else:
		flame.visible = true
		particles.emitting = true;
