extends CanvasLayer

# Curved hook slash
var points = [Vector2(150, 400), Vector2(300, 200), Vector2(500, 250), Vector2(550, 450)]

# Lightning bolt
var points1 = [Vector2(400, 100), Vector2(250, 280), Vector2(450, 320), Vector2(300, 500)]

# Spiral-ish
var points2 = [Vector2(600, 200), Vector2(300, 150), Vector2(200, 350), Vector2(400, 450)]

# Jagged multi-hit
var points4 = [Vector2(100, 300), Vector2(250, 150), Vector2(400, 350), Vector2(550, 180), Vector2(700, 320)]

# Swooping arc

var points3 = [Vector2(100, 450), Vector2(200, 200), Vector2(500, 180), Vector2(650, 400)]

var ara = [points, points1, points2,points3,points4]

# Curved hook (3 segments)
var tpoints = [0.2, 0.1, 0.5]

# Lightning bolt (3 segments) - quick jabs
var tpoints1 = [0.1, 0.3, 0.1]

# Spiral-ish (3 segments) - slow windup, fast finish
var tpoints2 = [0.4, 0.1, 0.05]

# Jagged multi-hit (4 segments) - rapid fire
var tpoints4 = [0.05, 0.1, 0.05, 0.1]

# Swooping arc (3 segments) - dramatic pause mid-swing
var tpoints3 = [0.1, 0.5, 0.1]

var art = [tpoints, tpoints1, tpoints2, tpoints4, tpoints3]
func _ready() -> void:
	var rand = randi() % ara.size()
	
	await get_tree().create_timer(2).timeout
	get_parent().atk_sequence(ara[rand], 0.5, art[rand])
