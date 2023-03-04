extends Node2D

var MIN_STARS = 10
var MAX_STARS = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in self.get_children():
		self.remove_child(child)

	for i in range(MIN_STARS, randi_range(MIN_STARS, MAX_STARS)):
		var dot = Line2D.new()
		var point = Vector2(
			randi_range(0, ProjectSettings.get_setting('display/window/size/viewport_width')),
			randi_range(0, ProjectSettings.get_setting('display/window/size/viewport_height'))
		)
		dot.points = [
			point,
			point + Vector2(1,1)
		]
		dot.default_color = Color(1,1,1)
		dot.width = 1
		self.add_child(dot)