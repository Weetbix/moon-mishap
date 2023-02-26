extends RigidBody2D

const ROTATE_SPEED = 100
const THRUST_AMOUNT = 40

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	# if not is_on_floor():
	# velocity.y += gravity * delta

	var rotate_amount = Input.get_action_strength("rotate-left") - Input.get_action_strength("rotate-right")
	apply_torque(-rotate_amount * ROTATE_SPEED)
	# rotation += rotate_amount * rotation_speed * delta

	var thruster_amount = Input.get_action_strength("thruster")
	var thrust = Vector2(0, -THRUST_AMOUNT) * thruster_amount
	apply_force(thrust.rotated(rotation))
