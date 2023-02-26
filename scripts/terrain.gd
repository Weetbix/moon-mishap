@tool
extends Node2D

@onready var line: Line2D = get_node("./line")
@onready var collision: CollisionPolygon2D = get_node("./static-body/collision")

@export var do_generate: bool = false:
	set(val):
		generate()

@export var noise_amplitude: float = 100.0
@export var noise_frequency: float = 0.08
@export var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX

var TERRAIN_X_POINTS = 65
var TERRAIN_X_SPACING = 10
var TERRAIN_HEIGHT = 400.0
var TERRAIN_Y_BASIS: float = 100.0

func match_line_to_collision():
	line.clear_points()
	line.position = collision.position
	line.points = collision.polygon
	line.add_point(collision.polygon[0])

func generate_collision_polygon():
	var noise = FastNoiseLite.new()  # Noise object for generating terrain
	noise.seed = randi()
	noise.noise_type = noise_type
	noise.frequency = noise_frequency

	var polygon = PackedVector2Array()
	for x in range(TERRAIN_X_POINTS + 1):
		var height_value = noise.get_noise_2d(x, 0)
		polygon.append(Vector2(x * TERRAIN_X_SPACING, height_value * noise_amplitude))
	
	polygon.append(Vector2(TERRAIN_X_POINTS * TERRAIN_X_SPACING, TERRAIN_HEIGHT))
	polygon.append(Vector2(0, TERRAIN_HEIGHT))
	return polygon

func generate():
	collision.polygon = generate_collision_polygon()
	collision.position = Vector2(
		float(-(TERRAIN_X_POINTS * TERRAIN_X_SPACING)/2.0),
		float(TERRAIN_Y_BASIS)
	)
	match_line_to_collision()

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
