extends Camera2D

@export var randstrength : float = 30.0
@export var shakefade : float = 5.0

var rng = RandomNumberGenerator.new()

var shakestr : float = 0.0

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("test"):
		#apply_shake()
		dzoom()
	
	if shakestr > 0:
		shakestr = lerpf(shakestr, 0, shakefade * delta)
		if shakestr < 0.5:
			shakestr = 0
			offset = Vector2.ZERO
		else:
			offset = randoffset()

func apply_shake():
	shakestr = randstrength

func dzoom():
	var tween = create_tween()
	await tween.tween_property(self, "zoom", Vector2(1.5,1.5), 0.1 )
	tween.tween_property(self, "zoom", Vector2(1,1), 0.1 )
	
func randoffset():
	return Vector2(randf_range(-shakestr, shakestr),randf_range(-shakestr, shakestr))
