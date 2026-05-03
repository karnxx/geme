extends Camera2D
@export var randstrength : float = 30.0
@export var shakefade : float = 5.0
var shakestr : float = 0.0

func _process(delta: float) -> void:
	if shakestr > 0:
		shakestr = lerpf(shakestr, 0, shakefade * delta)
		if shakestr < 0.5:
			shakestr = 0
			offset = Vector2.ZERO
		else:
			offset = randoffset()

func apply_shake():
	shakestr = randstrength

func dzoom(amt):
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(amt, amt), 0.1)
	tween.tween_property(self, "zoom", Vector2(1, 1), 0.3)

func zazoom(amt):
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(amt, amt), 0.2)

func randoffset():
	return Vector2(randf_range(-shakestr, shakestr), randf_range(-shakestr, shakestr))
