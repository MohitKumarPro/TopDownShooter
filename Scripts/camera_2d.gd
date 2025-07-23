extends Camera2D
@onready var hero =  $".."
var shake_strength = 2
var shake_time = 0.15
var original_offset := Vector2.ZERO
var shake_timer = 0.0
var rng = RandomNumberGenerator.new()
@onready var camera = $"."
@onready var tween = get_tree().create_tween()

func _ready():
	original_offset = offset
	rng.randomize()

func zoom_in_on_fire():
	# Zoom in and out
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(0.48, 0.48), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "zoom", Vector2(0.5, 0.5), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Start shake
	shake_timer = shake_time
	set_process(true)

func _process(delta):
	
	
	var mouse_world_pos = get_global_mouse_position()
	var player_pos = global_position
	var direction_to_mouse = (mouse_world_pos - player_pos).normalized()
	var camera_offset_strength = 300  # Increase for more forward visibility
	var offset1 = direction_to_mouse * camera_offset_strength
	offset = offset.lerp(offset1,delta*5)
	original_offset = offset
