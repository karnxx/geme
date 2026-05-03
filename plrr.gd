extends CharacterBody2D

var basespd = 700
var spd := 700
var lastspd
@export var curve :Curve
var t = 0
var last_dir = Vector2.ZERO
var candraw = false

var plrstart
var plrend

var current_line : Line2D


var last_atker

var base_atk = 10
var base_hp = 100
var base_stm = 10
var base_def = 0

var atkmod = 1
var hpmod = 1
var stmmod = 1
var defmod = 1

var atk = 0
var hp = 0
var stm = 0
var def = 0

var helm = null
var chest = null

var isgettingattacked = false
var isdashing = false
var isstancing = false
var isspawninghps

var atk_t = 0.0
var plr_line_times = []
var tip_history = []

var viginette_str = 0.0

var can_move = true

func _ready() -> void:
	InventoryManager.plrstantiate(self)
	TutorialManager.plrstantiate(self)
	statciate()
	viginette_set(0.0)

var dir
func _physics_process(delta: float) -> void:
	if !isdashing and can_move:
		dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		animate(dir)
	
	if isdashing:
		move_and_slide()
		return
	
	if Input.is_action_just_pressed("f") and !isstancing:
		parry_stance()
	
	if dir:
		velocity = dir * spd * curve.sample(t)
		last_dir = dir
		t += delta
		if t > 1:
			t = 1
	else:
		velocity = last_dir * spd * curve.sample(t)
		t -= delta
		if t < 0:
			t = 0
		last_dir = Vector2.ZERO
	for i in circs:
		if is_instance_valid(i) and is_instance_valid(current_line) and current_line.points.size() >= 1:
			var tip = current_line.points[current_line.points.size()-1]
			if tip.distance_to(i.position) < i.radius + 5:
				i.queue_free()
				if is_instance_valid(last_atker):
					last_atker.get_dmged(atk)
	if Input.is_action_just_pressed("ui_accept") and can_move:
		dash()
	move_and_slide()
	player_line()

func viginette_set(strength):
	viginette_str = strength
	$hud/ColorRect.material.set_shader_parameter("strength", strength)

func viginette_tween(tar, dur=0.3):
	var tween = create_tween()
	tween.tween_method(viginette_set, viginette_str, tar, dur)

func parry_stance():
	isstancing = true
	candraw = true
	lastspd = spd
	spd *= 0.2
	viginette_tween(0.3)
	get_tree().create_timer(2).timeout.connect(parry_over)

func animate(dir):
	if dir == Vector2.ZERO:
		$AnimatedSprite2D.pause()
		return
	if dir.x > 0:
		if dir.y > 0:
			$AnimatedSprite2D.play("dr")
		elif dir.y < 0 :
			$AnimatedSprite2D.play("ur")
		elif dir.y == 0:
			$AnimatedSprite2D.play("r")
	elif dir.x < 0:
		if dir.y > 0:
			$AnimatedSprite2D.play("dl")
		elif dir.y < 0 :
			$AnimatedSprite2D.play("ul")
		elif dir.y == 0:
			$AnimatedSprite2D.play("l")
	elif dir.x == 0:
		if dir.y > 0:
			$AnimatedSprite2D.play("d")
		elif dir.y < 0:
			$AnimatedSprite2D.play("u")

func parry_over():
	candraw = false
	spd = basespd
	isstancing = false
	viginette_tween(0)

func get_atked(sequence, dmg, who):
	if !isstancing:
		return await atk_sequence(sequence[0], sequence[1], sequence[2], who)
	else:
		get_dmged(dmg, who)

func dash():
	if isgettingattacked:
		return
	
	isdashing = true
	var lastvelo = velocity
	velocity *= 2
	await dashanimate()
	velocity = lastvelo
	isdashing = false

func dashanimate():
	if dir == Vector2.ZERO:
		if last_dir.x > 0:
			if last_dir.y > 0:
				$AnimatedSprite2D.play("d_dr")
				await $AnimatedSprite2D.animation_finished
			elif last_dir.y < 0 :
				$AnimatedSprite2D.play("d_ur")
				await $AnimatedSprite2D.animation_finished
			elif last_dir.y == 0:
				$AnimatedSprite2D.play("d_r")
				await $AnimatedSprite2D.animation_finished
		elif last_dir.x < 0:
			if last_dir.y > 0:
				$AnimatedSprite2D.play("d_dl")
				await $AnimatedSprite2D.animation_finished
			elif last_dir.y < 0 :
				$AnimatedSprite2D.play("d_ul")
				await $AnimatedSprite2D.animation_finished
			elif last_dir.y == 0:
				$AnimatedSprite2D.play("d_l")
				await $AnimatedSprite2D.animation_finished
		return
	elif dir.x == 0:
		if dir.y > 0:
			$AnimatedSprite2D.play("d_d")
			await $AnimatedSprite2D.animation_finished
		elif dir.y < 0:
			$AnimatedSprite2D.play("d_u")
			await $AnimatedSprite2D.animation_finished
	if dir.x > 0:
		if dir.y > 0:
			$AnimatedSprite2D.play("d_dr")
			await $AnimatedSprite2D.animation_finished
		elif dir.y < 0 :
			$AnimatedSprite2D.play("d_ur")
			await $AnimatedSprite2D.animation_finished
		elif dir.y == 0:
			$AnimatedSprite2D.play("d_r")
			await $AnimatedSprite2D.animation_finished
	elif dir.x < 0:
		if dir.y > 0:
			$AnimatedSprite2D.play("d_dl")
			await $AnimatedSprite2D.animation_finished
		elif dir.y < 0 :
			$AnimatedSprite2D.play("d_ul")
			await $AnimatedSprite2D.animation_finished
		elif dir.y == 0:
			$AnimatedSprite2D.play("d_l")
			await $AnimatedSprite2D.animation_finished
	elif dir.x == 0:
		if dir.y > 0:
			$AnimatedSprite2D.play("d_d")
			await $AnimatedSprite2D.animation_finished
		elif dir.y < 0:
			$AnimatedSprite2D.play("d_u")
			await $AnimatedSprite2D.animation_finished
	return

func statciate():
	atk = round(base_atk * atkmod)
	stm = round(base_stm * stmmod)
	hp = round(base_hp * hpmod)
	def = round(base_def * defmod)

func armorstantiate():
	if helm != null:
		atkmod += helm.atkmod
		hpmod += helm.hpmod
		stmmod += helm.stmmod
		defmod += helm.defmod
	if chest != null:
		atkmod += chest.atkmod
		hpmod += chest.hpmod
		stmmod += chest.stmmod
		defmod += helm.defmod
	statciate()

func flash(points):
	var line = Line2D.new()
	line.points = points
	line.default_color = Color.RED
	line.name = "flashline"
	$hud.add_child(line)
	await get_tree().create_timer(0.05).timeout
	line.visible = !line.visible
	await get_tree().create_timer(0.05).timeout
	line.visible = !line.visible
	await get_tree().create_timer(0.05).timeout
	line.visible = !line.visible
	await get_tree().create_timer(0.05).timeout
	line.visible = !line.visible
	line.queue_free()

var circs = []
func spawnhps(number : int):
	isspawninghps = true
	candraw = true
	var pos = Vector2(randf_range(0,get_viewport().get_visible_rect().size.x), randf_range(0,get_viewport().get_visible_rect().size.y))
	if number == 0:
		return
	for i in range(number):
		var circ = preload("res://tscns/circledrawer.tscn").instantiate()
		$hud.add_child(circ)
		circ.position = pos
		circs.append(circ)
		circ.queue_redraw()
		pos = Vector2(randf_range(0,get_viewport().get_visible_rect().size.x), randf_range(0,get_viewport().get_visible_rect().size.y))
	var t = 0
	while t < 1:
		for i in circs:
			if is_instance_valid(i):
				i.radius -= 4
				if i.radius <= 10:
					i.queue_free()
				i.queue_redraw()
		t += 0.1
		await get_tree().create_timer(0.4).timeout
	isspawninghps = false

func atk_sequence(points :Array, time : float, timestops: Array, who = self) -> bool:
	candraw = true
	lastspd = spd
	spd *= 0.2
	isgettingattacked = true
	last_atker = who
	atk_t = 0.0
	tip_history = []
	var line = Line2D.new()
	var ttl = points.size()
	var ponts : Array
	var t = 0
	$Camera2D.zazoom(1.3)
	flash(points)
	await get_tree().create_timer(1).timeout
	line.name = "atk"
	$hud.add_child(line)
	viginette_tween(0.3)

	var segments = ttl - 1
	var progress = 0
	var current_seg = 0
	var seg_prog = 0
	var start = 0
	var end = 0
	var tip = Vector2.ZERO
	var prevseg = 0
	var curseg = 0

	while t < 1:
		atk_t = t
		line.clear_points()
		progress = t * segments
		current_seg = int(progress)
		seg_prog = progress - current_seg
		start = points[current_seg]
		end = points[current_seg + 1]
		ponts.append(lerp(start, end, seg_prog))
		tip = lerp(start, end, seg_prog)
		line.points = ponts
		
		tip_history.append(tip)
		if tip_history.size() > 8:
			tip_history.pop_front()
		
		if curseg != current_seg:
			prevseg = curseg
			if prevseg < timestops.size():
				await get_tree().create_timer(timestops[prevseg]).timeout
		
		if t > 0.3 and t < 1:
			if is_instance_valid(current_line) and current_line.points.size() >= 2:
				for j in range(current_line.points.size() - 1):
					if j < plr_line_times.size() and abs(plr_line_times[j] - atk_t) < 0.15:
						for k in range(tip_history.size() - 1):
							var intersect = Geometry2D.segment_intersects_segment(
								tip_history[k], tip_history[k+1],
								current_line.points[j], current_line.points[j+1]
							)
							if intersect != null:
								$Camera2D.dzoom(1.8)
								if who.spawnhps:
									spawnhps((10 - int(t*10))-3)
								$Camera2D.apply_shake()
								line.queue_free()
								isgettingattacked = false
								spd = basespd
								SignalManager.atk_seq_ovr.emit(true)
								viginette_tween(1.0)
								await get_tree().create_timer(0.1).timeout
								viginette_tween(0)
								$Camera2D.dzoom(1)
								return true
		
		t += get_process_delta_time()/time
		curseg = current_seg
		await get_tree().process_frame

	await get_tree().create_timer(0.5).timeout
	get_dmged(who.atk, who)
	isgettingattacked = false
	spd = basespd
	line.queue_free()
	SignalManager.atk_seq_ovr.emit(false)
	viginette_tween(0)
	$Camera2D.zazoom(1)
	return false

func player_line():
	if Input.is_action_just_pressed('lmb') and candraw:
		plrstart = get_viewport().get_mouse_position()
		current_line = Line2D.new()
		plr_line_times = []
		$hud.add_child(current_line)
		current_line.add_point(plrstart)
		plr_line_times.append(atk_t)
		viginette_tween(0.7)
		$Camera2D.zazoom(1.5)
		get_tree().create_timer(0.8).timeout.connect(lineover)
	if Input.is_action_pressed("lmb") and candraw and plrstart != null:
		current_line.add_point(get_viewport().get_mouse_position())
		plr_line_times.append(atk_t)
		if current_line.get_point_count() > 20:
			current_line.remove_point(0)
			plr_line_times.pop_front()
	if Input.is_action_just_released("lmb") and candraw and plrstart != null:
		candraw = false
		plrstart = null
		plrend = null
		viginette_tween(0.3)
		get_tree().create_timer(3).timeout.connect(current_line.queue_free)
		get_tree().create_timer(0.2).timeout.connect(cd_over)
	stm -= 1

func cd_over():
	if isgettingattacked or isspawninghps:
		candraw = true

func lineover():
	if plrstart == null:
		return
	plrend = get_viewport().get_mouse_position()
	current_line.add_point(plrend)
	plr_line_times.append(atk_t)
	candraw = false
	plrstart = null
	plrend = null
	viginette_tween(0.3)
	$Camera2D.zazoom(1.4)
	get_tree().create_timer(3).timeout.connect(current_line.queue_free)
	get_tree().create_timer(0.2).timeout.connect(cd_over)

func get_dmged(dmg, who):
	hp -= round(dmg - (def * dmg)/2)
