extends CharacterBody2D
var pos:Vector2
var rota:float
var dir: float
var speed = 2500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	global_rotation = rota

func set_bullet_type(type: String):
	match type:
		"hero":
			$Sprite2D.texture = preload("res://Assets/Laser Sprites/01.png")
		"robo":
			$Sprite2D.texture = preload("res://Assets/Laser Sprites/02.png")

func set_bullet_size(scale_factor: Vector2):
	$Sprite2D.scale = scale_factor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
