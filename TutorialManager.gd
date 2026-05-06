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

var tutext

func dummystantiate(dum):
	dummy = dum

func plrstantiate(pr):
	plr =  pr

var busy = false

var t4text = false
var t5text = false
var t6text = false

var texts = ["oooof... lets try that again..", "okok its fine lets try again", "alr lock in this time", "hmm again!", "remember try to draw it at the center", "again!!", "its not that deep bro try again" ]

func _process(delta: float) -> void:
	if t1over == false and !busy:
		tutext = plr.get_parent().get_node('tutorial')
		busy = true
		plr.can_move = false
		tutext.text = "hey!! im the training dummy..."
		await get_tree().create_timer(2).timeout
		tutext.text = "ill be teaching u how to play this game!."
		await get_tree().create_timer(2).timeout
		tutext.text = "so to move, it is wasd."
		plr.can_move = true
		await get_tree().create_timer(0.5).timeout
		while not t1over:
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
				t1over = true
			await get_tree().process_frame
		busy = false
	if t2over == false and !busy:
		busy = true
		tutext.text = "cool! dodging is an important part of the game, which can allow you to dodge projectiles which are hard to parry."
		await get_tree().create_timer(2).timeout
		tutext.text = "alr to dodge is it space or enter."
		await get_tree().create_timer(0.5).timeout
		while t2over == false:
			if Input.is_action_just_pressed("ui_accept"):
				t2over = true
				await get_tree().create_timer(0.5).timeout
				tutext.text = "nice! so now i will introduce you to the parrying in this game."
				await get_tree().create_timer(2).timeout
				tutext.text = "so enemy lines will be drawn across the screen. you have to intercept those lines by drawing a line yourself, as close to the beginning but not too close to the beginning."
				await get_tree().create_timer(4).timeout
			await get_tree().process_frame
		busy = false
	if t2over and not t3over and not is_waiting and !busy:
		busy = true
		if !t4text:
			t4text = true
			tutext.text = "to normally parry u have to press f, which will bring u to a parry stance, u use this for projectiles."
			await get_tree().create_timer(3).timeout
			tutext.text = "alr get ready."
			await get_tree().create_timer(2).timeout
		dummy.spawnhps = false
		dummy.can_atk = true
		is_waiting = true
		var result = await dummy.try_atk()
		is_waiting = false
		if result == true:
			t3over = true
			busy = false
			await get_tree().create_timer(2).timeout
		else:
			tutext.text = texts.pick_random()
			await get_tree().create_timer(1).timeout
			busy = false
	if t3over and not t4over and not is_waiting and !busy:
		busy = true
		if !t5text:
			tutext.text = "alr wwww."
			await get_tree().create_timer(1).timeout
			tutext.text = "to actually damage the opponent, after parrying red circles spawn"
			await get_tree().create_timer(2).timeout
			tutext.text = "u hit the red circles and dmg the enemy. the dmg scales with ur atk stat and decreases with the opponenets armor."
			await get_tree().create_timer(2).timeout
			tutext.text = "now i will attack u again, try to hit the red circles."
			await get_tree().create_timer(2).timeout
			t5text = true
		dummy.spawnhps = true
		dummy.can_atk = true
		is_waiting = true
		var result = await dummy.try_atk()
		is_waiting = false
		if result == true:
			tutext.text = "great! now its the next mechanic which is projectiles."
			await get_tree().create_timer(2).timeout
			tutext.text = "projectiles r hella annoying so dodgin them is optimal."
			t4over = true
			dummy.can_atk = false
			dummy.spawnhps = false
			await get_tree().create_timer(2).timeout
			busy = false
		else:
			tutext.text = texts.pick_random()
			await get_tree().create_timer(1).timeout
			busy = false
	if t4over and not t5over and not is_waiting and !busy:
		busy = true
		if !t6text:
			t6text = true
			tutext.text = "ill be shooting a projectile. first try dodging them, then try getting hit by them, to get into the parry sequence for the projectiles, press f before it hits u."
			await  get_tree().create_timer(4).timeout
			tutext.text = "aight to dodge press space. get ready, in 5 secs ill use a projectile, press f!"
			await get_tree().create_timer(5).timeout
		is_waiting = true
		dummy.can_spawn_proj = true
		dummy.projectile(1)
		var result = await dummy.returned
		await get_tree().create_timer(0.5).timeout
		is_waiting = false
		if result == true:
			t5over = true
			tutext.text = "alr that was the tutorial. heres a boss fight ;)"
			dummy.atk = 10
			dummy.hp = 100
			await get_tree().create_timer(5).timeout
			dummy.canfballorsweep = true
			dummy.cantap  = true
			dummy.tutoaver = true
			tutover = true
			dummy.can_atk = true
			dummy.can_spawn_proj = true
			busy = false
		elif result == false:
			tutext.text = "alr try getting hit by them, remember hit f or u get dmged"
			await get_tree().create_timer(2).timeout
			tutext.text = "get ready.."
			await get_tree().create_timer(1).timeout
			busy = false
	if Input.is_action_just_pressed('test'):
		dummy.projectile(1)

	if tutover == true:
		self.queue_free()
