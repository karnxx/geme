extends CharacterBody2D

var can_move_box = true
var plr 
func _process(delta: float) -> void:
	plr = get_parent().get_node('plrr')
	if can_move_box and plr:
		$pivot.rotation = global_position.angle_to_point(plr.global_position)
