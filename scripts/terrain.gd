@tool
extends Node2D

@onready var line: Line2D = get_node("./line")
@onready var collision: CollisionPolygon2D = get_node("./static-body/collision")

@export var do_generate: bool = false:
	set(val):
		generate()

var TERRAIN_X_POINTS = 65
var TERRAIN_X_SPACING = 10
var TERRAIN_HEIGHT = 400.0
var TERRAIN_Y_BASIS: float = 100.0

func smooth_y_values(points: Array):
	var smoothedPoints = PackedVector2Array()

	# Smooth the y values of the points using a weighted average
	for i in range(0, points.size()):
		# Get the y value of the current point
		var y = points[i].y

		# Calculate the weighted average of the y value
		if i > 0 and i < points.size() - 1:
			y = (points[i - 1].y + 2 * points[i].y + points[i + 1].y) / 4

		# Add the smoothed point to the list of smoothed points
		smoothedPoints.append(Vector2(points[i].x, y))

	return smoothedPoints


func match_line_to_collision():
	line.clear_points()
	line.position = collision.position
	line.points = collision.polygon
	line.add_point(collision.polygon[0])

func generate_collision_polygon():
	var polygon = PackedVector2Array()
	for i in range(TERRAIN_X_POINTS + 1):
		polygon.append(Vector2(i * TERRAIN_X_SPACING, randi_range(-100, 100)))
		# polygon.append(Vector2(rand_range(-1, 1), rand_range(-1, 1)))
		# polygon.append(Vector2(i * TERRAIN_X_SPACING, 0))
	
	polygon.append(Vector2(TERRAIN_X_POINTS * TERRAIN_X_SPACING, TERRAIN_HEIGHT))
	polygon.append(Vector2(0, TERRAIN_HEIGHT))
	return polygon

func generate():
	collision.polygon = smooth_y_values(smooth_y_values(generate_collision_polygon()))
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
