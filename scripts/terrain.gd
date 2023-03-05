@tool
extends Node2D
class_name Terrain

signal platform_created(position: Vector2, difficulty: float)

@onready var line: Line2D = $line
@onready var collision: CollisionPolygon2D = $static_body/collision
@onready var polygon: Polygon2D = $static_body/polygon
@onready var particle_collider: LightOccluder2D = $particle_collider
@onready var platforms: Node = $platforms

@export var noise_amplitude: float = 100.0
@export var noise_frequency: float = 0.08
@export var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX

var TERRAIN_X_POINTS = 65
var TERRAIN_X_SPACING = 10
var TERRAIN_HEIGHT = 400.0
var TERRAIN_Y_BASIS: float = 300.0

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

	for i in range(1, points.size() -3):
		var difference_in_neighours = abs(points[i].y - points[i-1].y) + abs(points[i].y - points[i+1].y)
		if difference_in_neighours < smoothest_value:
			smoothest_index = i
			smoothest_value = difference_in_neighours
	
	return smoothest_index

func find_jankiest_point(points: PackedVector2Array):
	var jankiest_index = 1
	var jankiest_value = -1000

	for i in range(1, points.size() -3):
		# Jank value is like deep caves, so lets find the point where the height difference
		# of both neighbours adds up to the most
		var jank_amount = (points[i-1].y + points[i].y) + (points[i+1].y + points[i].y)
		if jank_amount > jankiest_value:
			jankiest_index = i
			jankiest_value = jank_amount
	
	return jankiest_index

func make_neighbours_flat(points: PackedVector2Array, index: int):
	points[index-1].y = points[index].y
	points[index+1].y = points[index].y

func remove_all_platforms():
	for child in platforms.get_children():
		platforms.remove_child(child)

func create_platform(terrain: PackedVector2Array, index: int, color: Color):
	var platform_line = Line2D.new()
	platform_line.points = [
		terrain[index-1], 
		terrain[index+1]
	]
	platform_line.default_color = color
	platform_line.width = 1
	platforms.add_child(platform_line)

func generate():
	var terrain_array = generate_collision_polygon();

	var smoothest_point = find_smoothest_point(terrain_array)
	var jankiest_point = find_jankiest_point(terrain_array)

	make_neighbours_flat(
		terrain_array,
		smoothest_point
	)
	make_neighbours_flat(
		terrain_array,
		jankiest_point
	)

	collision.polygon = terrain_array
	polygon.polygon = terrain_array
	particle_collider.occluder.polygon = terrain_array
	position = Vector2(
		0,
		float(TERRAIN_Y_BASIS)
	)

	remove_all_platforms()
	create_platform(collision.polygon, smoothest_point, Color(0,1,0))
	create_platform(collision.polygon, jankiest_point, Color(1,0,0))
	platform_created.emit(position + terrain_array[smoothest_point], 1.0)
	platform_created.emit(position + terrain_array[jankiest_point], 2.0)

	match_line_to_collision()
