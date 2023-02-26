@tool
extends Node2D

@onready var line: Line2D = get_node("./line")
@onready var collision: CollisionPolygon2D = get_node("./collision")

@export var do_generate: bool = false:
	set(val):
		generate()


var  TERRAIN_X_POINTS = 30
var TERRAIN_X_SPACING = 10
var TERRAIN_HEIGHT = 400

func match_line_to_collision():
	line.clear_points()
	line.position = collision.position
	line.points = collision.polygon
	line.add_point(collision.polygon[0])

func generate_collision_polygon():
	var polygon = PackedVector2Array()
	for i in range(TERRAIN_X_POINTS):
		# polygon.append(Vector2(rand_range(-1, 1), rand_range(-1, 1)))
		polygon.append(Vector2(i * TERRAIN_X_SPACING, 0))
	
	polygon.append(Vector2(TERRAIN_X_POINTS * TERRAIN_X_SPACING, TERRAIN_HEIGHT))
	polygon.append(Vector2(0, TERRAIN_HEIGHT))
	return polygon

func generate():
	print('generating')
	collision.polygon = generate_collision_polygon()
	match_line_to_collision()

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
