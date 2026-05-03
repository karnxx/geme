extends Node

var tutover = false
var t1over = false
var t2over = false
var t3over = false
var t4over = false
var t5over = false

var plr
var dummy
var is_waiting = false

func dummystantiate(dum):
	dummy = dum

func plrstantiate(pr):
	plr =  pr

func _process(delta: float) -> void:
	
	if (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and t1over == false:
		t1over = true
	if Input.is_action_just_pressed("ui_accept") and t2over == false:
		t2over = true
	if t2over and not t3over and not is_waiting:
		print('aka')
		dummy.can_atk = true
		is_waiting = true
		var result = await dummy.try_atk()
		is_waiting = false
		if result == true:
			t3over = true
	if t3over and not t4over and not is_waiting:
		dummy.spawnhps = true
		dummy.can_atk = true
		is_waiting = true
		var result = await dummy.try_atk()
		is_waiting = false
		if result == true:
			print('detects the hps done')
			t4over = true
			dummy.can_atk = false
			dummy.spawnhps = false
	if t4over and not t5over and not is_waiting:
		is_waiting = true
		dummy.can_spawn_proj = true
		dummy.projectile(1)
		var result = await dummy.returned
		await get_tree().create_timer(0.5).timeout
		is_waiting = false
		if result == true:
			t5over = true
			dummy.atk = 10
			dummy.hp = 100
			await get_tree().create_timer(5).timeout
			dummy.tutoaver = true
			tutover = true
			dummy.can_atk = true
			dummy.can_spawn_proj = true
	if Input.is_action_just_pressed('test'):
		dummy.projectile(1)

	if tutover == true:
		self.queue_free()
