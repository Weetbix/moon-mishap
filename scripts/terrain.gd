@tool
extends Node2D

@onready var line: Line2D = get_node("./line")
@onready var collision: CollisionPolygon2D = get_node("./static-body/collision")
@onready var platforms: Node = get_node("./platforms")

# Generate terrain when hitting the "do toggle" checkbox
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

func find_smoothest_point(points: PackedVector2Array):
	var smoothest_index = 1
	var smoothest_value = 10000

	for i in range(1, points.size() -1):
		var difference_in_neighours = abs(points[i].y - points[i-1].y) + abs(points[i].y - points[i+1].y)
		if difference_in_neighours < smoothest_value:
			smoothest_index = i
			smoothest_value = difference_in_neighours
	
	return smoothest_index

func make_neighbours_flat(points: PackedVector2Array, index: int):
	points[index-1].y = points[index].y
	points[index+1].y = points[index].y

func remove_all_platforms():
	for child in platforms.get_children():
		platforms.remove_child(child)

func create_platform(terrain: PackedVector2Array, index: int):
	var platform_line = Line2D.new()
	platform_line.points = [
		terrain[index-1], 
		terrain[index+1]
	]
	platform_line.default_color = Color(0, 1, 0)
	platform_line.width = 1
	platforms.add_child(platform_line)

func generate():
	var terrain_array = generate_collision_polygon();

	var smoothest_point = find_smoothest_point(terrain_array)
	make_neighbours_flat(
		terrain_array,
		smoothest_point
	)

	collision.polygon = terrain_array
	position = Vector2(
		float(-(TERRAIN_X_POINTS * TERRAIN_X_SPACING)/2.0),
		float(TERRAIN_Y_BASIS)
	)
	remove_all_platforms()
	create_platform(collision.polygon, smoothest_point)
	match_line_to_collision()

func _ready():
	if not Engine.is_editor_hint():
		generate()

func _process(_delta):
	if Input.is_action_just_pressed("debug_generate_terrain"):
		generate()
