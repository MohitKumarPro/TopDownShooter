extends CharacterBody2D

@export var move_speed := 200.0
@onready var body = $HeadGunSprite
@onready var feet = $FeetSprite
var can_fire = true
func _physics_process(delta: float) -> void:
	handle_movement(delta)
	look_at_mouse()

func handle_movement(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity = input_vector * move_speed
		HandGunMove()
		FeetForward()
	else:
		HandGunIdeal()
		FeetIdeal()
		velocity = Vector2.ZERO
	
	#if Input.is_action_pressed("MouseButton"):
	#	HandGunShoot()
	move_and_slide()


func look_at_mouse() -> void:
	var mouse_pos := get_global_mouse_position()
	look_at(mouse_pos)

func HandGunMove():
	if !Input.is_action_pressed("MouseButton"):
		body.play("HandGunMove")
	else:
		if Input.is_action_just_pressed("MouseButton") and can_fire:
			HandGunShoot()
			can_fire = false
			await get_tree().create_timer(0.2).timeout
			can_fire = true

func HandGunIdeal():
	if !Input.is_action_pressed("MouseButton"):
		body.play("HandGunIdeal")
	else:
		if Input.is_action_just_pressed("MouseButton") and can_fire:
			HandGunShoot()
			can_fire = false
			await get_tree().create_timer(0.1).timeout
			can_fire = true
		
	
func FeetForward():
	if !Input.is_action_pressed("MouseButton"):
		feet.play("FeetForward")

func FeetIdeal():
	feet.play("FeetIdeal")

func FeetLeft():
	feet.play("FeetLeft")

func FeetRight():
	feet.play("FeetRight")

func HandGunShoot():
	body.play("HandGunShoot")
	fire()

func fire():
	var bullet_path = preload("res://Scenes/bullet.tscn")
	var bullet = bullet_path.instantiate()
	bullet.dir = rotation
	bullet.pos = $Marker2DFront.global_position
	bullet.rota = global_rotation
	get_parent().add_child(bullet)
