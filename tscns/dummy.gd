extends CharacterBody2D

var points = [Vector2(200, 150), Vector2(600, 450)]
var tpoints = []
var tim = 2.0

var points1 = [Vector2(150, 250), Vector2(400, 400), Vector2(650, 250)]
var tpoints1 = [0.6]
var tim1 = 1.8

var points2 = [Vector2(100, 200), Vector2(350, 350), Vector2(550, 200), Vector2(700, 400)]
var tpoints2 = [0.5, 0.5]
var tim2 = 1.5

var pointas = [points, points1, points2]
var tpointas = [tpoints, tpoints1,tpoints2]
var timas = [tim,tim1, tim2]

var can_move_box = true
var plr 

var is_plr_in_atkreach = false
var is_plr_in_range = false

var def = 1000
var atk = 0
var stm = 1000
var hp = 10000000000

var can_atk = false
var spawnhps = false

var last_return = false

var can_spawn_proj = false

func _ready() -> void:
	TutorialManager.dummystantiate(self)

func _process(delta: float) -> void:
	if TutorialManager.t3over == false and TutorialManager.t2over == true:
		can_atk == true
	plr = get_parent().get_node('plrr')
	if can_move_box and plr:
		$pivot.rotation = global_position.angle_to_point(plr.global_position)
	if can_atk and is_plr_in_atkreach and is_plr_in_range and plr:
		try_atk()

func get_dmged(dmg):
	hp -= dmg

func try_atk():
	if !can_atk:
		return
	print('asd')
	var randa = randi() % pointas.size()
	var randpoint = pointas[randa]
	var randtpoint = tpointas[randa]
	var time = timas[randa]
	var seqarray =[randpoint, time, randtpoint]
	
	var dmg = atk
	
	can_atk = false
	var ret = await plr.get_atked(seqarray, dmg, self)
	await get_tree().create_timer(2).timeout
	can_atk = true
	return ret

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'plrr':
		is_plr_in_atkreach = true

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == 'plrr':
		is_plr_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'plrr':
		is_plr_in_atkreach = false

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.name == 'plrr':
		is_plr_in_range = false

func projectile(number):
	if !can_spawn_proj:
		return
	for i in range(number):
		var proj = preload("res://tscns/fireball.tscn").instantiate()
		proj.user = self
		get_parent().add_child(proj)

func free_return(retur):
	last_return = retur
	return retur
