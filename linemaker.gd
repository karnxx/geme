extends Node2D

var points = []
var line : Line2D

func _ready():
	line = Line2D.new()
	line.width = 3
	add_child(line)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		points.append(get_global_mouse_position())
		line.add_point(get_global_mouse_position())
	if event is InputEventKey and event.pressed and event.keycode == KEY_P:
		print(points)
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		points = []
		line.clear_points()
