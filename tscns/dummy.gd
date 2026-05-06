extends CharacterBody2D
var points = [Vector2(841.0, 247.0), Vector2(492.0, 177.0), Vector2(177.0, 374.0)]
var tpoints = [0.4,0.4]
var tim = 2.0
var points1 = [Vector2(823.0, 218.0), Vector2(541.0, 142.0), Vector2(283.0, 267.0), Vector2(180.0, 378.0)]
var tpoints1 = [0.6, 0.6, 0.4]
var tim1 = 1.8
var points2 = [Vector2(111.0, 419.0), Vector2(674.0, 80.0), Vector2(1060.0, 276.0)]
var tpoints2 = [0.5, 0.5]
var tim2 = 1.5
var pointas = [points, points1, points2]
var tpointas = [tpoints, tpoints1, tpoints2]
var timas = [tim, tim1, tim2]
var can_move_box = true
var plr
var is_plr_in_atkreach = false
var is_plr_in_range = false
var def = 1000
var atk = 0
var stm = 1000
var hp = 10000000000
var tutoaver = false
var can_atk = false
var spawnhps = false
var last_return = false
var can_spawn_proj = false
var is_acting = false

var canfballorsweep = false
var cantap = false

signal returned
func _ready() -> void:
	if is_instance_valid(TutorialManager):
		TutorialManager.dummystantiate(self)

var action_cooldown = 0.0

func _process(delta: float) -> void:
	plr = get_parent().get_node('plrr')
	if can_move_box and plr:
		$pivot.rotation = global_position.angle_to_point(plr.global_position)
	if is_acting or !tutoaver:
		return
	if tutoaver:
		fballorsweep()
		randomada()

func fballorsweep():
	if !canfballorsweep:
		return
	var rand = randi_range(0,1)
	if rand == 1:
		fireballround()
	else:
		sweep()
	await get_tree().create_timer(2).timeout
	canfballorsweep = true

func randomada():
	if !cantap:
		return
	randomtp()
	await get_tree().create_timer(0.5).timeout
	cantap = true

func fireballround():
	is_acting = true
	projectile(10, 0.4)
	await get_tree().create_timer(4).timeout
	is_acting = false

func get_dmged(dmg):
	hp -= dmg

func try_atk():
	is_acting = true
	if is_instance_valid(TutorialManager) and TutorialManager.t3over:
		spawnhps = true
	var randa = randi() % pointas.size()
	var randpoint = pointas[randa]
	var randtpoint = tpointas[randa]
	var time = timas[randa]
	var seqarray = [randpoint, time, randtpoint]
	var dmg = atk
	var ret = await plr.get_atked(seqarray, dmg, self, "melee")
	spawnhps = false
	await get_tree().create_timer(2).timeout
	is_acting = false
	return ret

func sweep():
	var pos = (plr.global_position - global_position)
	if pos.x > 0 and pos.y > 0:
		$atk.play("dr")
		$dr.monitoring = true
		await $atk.animation_finished
		$dr.monitoring = false
	elif pos.x < 0 and pos.y > 0:
		$atk.play("dl")
		$dl.monitoring = true
		await $atk.animation_finished
		$dl.monitoring = false
	elif pos.x < 0 and pos.y < 0:
		$atk.play("ul")
		$ul.monitoring = true
		await $atk.animation_finished
		$ul.monitoring = false
	elif pos.x > 0 and pos.y < 0:
		$atk.play("ur")
		$ur.monitoring = true
		await $atk.animation_finished
		$ur.monitoring = false

func sweep_col(body):
	if body.name == 'plrr':
		try_atk()
		pass

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

func projectile(number, time=0.1):
	if !can_spawn_proj:
		return
	spawnhps = false
	for i in range(number):
		var proj = preload("res://tscns/fireball.tscn").instantiate()
		proj.global_position = global_position
		proj.user = self
		get_parent().add_child(proj)
		await get_tree().create_timer(time).timeout

func randomtp():
	is_acting = true
	var pos = plr.global_position
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween()
	tween.tween_property(self, "global_position", pos, 0.3)
	await get_tree().create_timer(2).timeout
	is_acting = false

func free_return(retur):
	last_return = retur
	returned.emit(retur)
	return retur
