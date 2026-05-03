extends CharacterBody2D
var user 
var target : Vector2
var start 
var spd = 700
var dir

var isatking = false

func _ready() -> void:
	await get_tree().process_frame
	target = get_parent().get_node('plrr').global_position
	start = global_position
	get_tree().create_timer(2).timeout.connect(dissapear)
	dir = (target - global_position).normalized()

func dissapear():
	user.free_return(false)
	queue_free()

func world_to_screen(pos) -> Vector2:
	return get_viewport().get_canvas_transform() * pos

func get_screen_edge_point(screen_start, screeendir) -> Vector2:
	var rect = get_viewport().get_visible_rect()
	var far = screen_start + screeendir * 10000

	var edges = [
		[Vector2(rect.position.x, rect.position.y), Vector2(rect.end.x, rect.position.y)],
		[Vector2(rect.position.x, rect.end.y), Vector2(rect.end.x, rect.end.y)],
		[Vector2(rect.position.x, rect.position.y), Vector2(rect.position.x, rect.end.y)],
		[Vector2(rect.end.x, rect.position.y), Vector2(rect.end.x, rect.end.y)]
	]
	
	for edge in edges:
		var intersect = Geometry2D.segment_intersects_segment(screen_start, far, edge[0], edge[1])
		if intersect != null:
			return intersect
	
	return far

func _process(delta: float) -> void:
	if user != null:
		velocity = dir * spd
		move_and_slide()
		rotation = get_angle_to(target)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'plrr' and !isatking:
		isatking = true
		var screen_start = world_to_screen(start)
		var screeendir = (world_to_screen(global_position) - screen_start).normalized()
		var p1 = get_screen_edge_point(screen_start, screeendir)
		var p2 = get_screen_edge_point(screen_start, -screeendir)
		var points = [p2, p1]
		var time = 0.8
		var timestops = [0.1]
		var arara = [points, time, timestops]
		
		body.get_atked(arara, user.atk, user)
		user.free_return(true)
		queue_free()
