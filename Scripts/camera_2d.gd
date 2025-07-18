extends Camera2D

var shake_strength = 2
var shake_time = 0.15
var original_offset := Vector2.ZERO
var shake_timer = 0.0
var rng = RandomNumberGenerator.new()

@onready var tween = get_tree().create_tween()

func _ready():
	original_offset = offset
	rng.randomize()

func zoom_in_on_fire():
	# Zoom in and out
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(0.45, 0.45), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "zoom", Vector2(0.5, 0.5), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Start shake
	shake_timer = shake_time
	set_process(true)

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		offset = original_offset + Vector2(
			rng.randf_range(-shake_strength, shake_strength),
			rng.randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = original_offset
		set_process(false)
