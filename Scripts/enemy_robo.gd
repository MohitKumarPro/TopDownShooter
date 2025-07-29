extends CharacterBody2D

@export var hero: NodePath
@export var move_speed: float = 200.0
@export var firing_angle_deg: float = 360.0
@export var distance_to_start_fight: float = 2000.0
@export var max_health: float = 100.0
@onready var Robo = $AnimatedSprite2D
var current_health: float
var state: String = "idle"
var start_rotation: float = 0.0
var target_position: Vector2
var accumulated_rotation_deg: float = 0.0
var previous_rotation: float = 0.0
@onready var AudioController = $"../HeroBody/AudioController"
var can_fire=true
var shooting = false

func _ready():
	current_health = max_health

func _physics_process(delta):
	var hero_node = get_node_or_null(hero)
	if hero_node == null:
		return
	
	var distance = global_position.distance_to(hero_node.global_position)

	if current_health <= max_health * 0.75:
		stop_all_actions()
		return

	match state:
		"idle":
			if distance < distance_to_start_fight:
				state = "shooting"
				start_rotation = rotation
				start_shooting()
		
		"shooting":
			var target_angle = (hero_node.global_position - global_position).angle()
			rotation = rotate_toward(rotation, target_angle, deg_to_rad(80) * delta*0.5)
			var delta_angle = abs(rad_to_deg(shortest_angle(previous_rotation, rotation)))
			accumulated_rotation_deg += delta_angle
			previous_rotation = rotation

			if !shooting and abs(rotation - target_angle) < deg_to_rad(5):
				start_shooting()

			if shooting and accumulated_rotation_deg >= firing_angle_deg:
				stop_shooting()
				state = "moving"
				target_position = hero_node.global_position

				
		"moving":
			accumulated_rotation_deg = 0
			var direction = (target_position - global_position).normalized()
			look_at(target_position)
			velocity = direction * move_speed
			move_and_slide()
			Robo.play("Run")
			if global_position.distance_to(target_position) < 10:
				velocity = Vector2.ZERO
				state = "shooting"
				start_rotation = rotation
				start_shooting()
	if shooting and can_fire:
		Robo.play("ShootGun")
		AudioController.RoboGun_play()
		var bullet_path = preload("res://Scenes/bullet.tscn")
		var bullet = bullet_path.instantiate()
		bullet.set_bullet_size(Vector2(1, 1))
		bullet.speed = 3000
		bullet.dir = rotation
		bullet.set_bullet_type("robo")
		bullet.pos = $Marker2DFrontEnemy.global_position
		bullet.rota = global_rotation
		get_parent().add_child(bullet)
		can_fire = false
		await get_tree().create_timer(0.1).timeout
		can_fire = true

func start_shooting():
	Robo.play("AimGun")
	await $AnimatedSprite2D.animation_finished
	shooting = true
	# Example: emit bullet every frame or use Timer-based system
	print("Start Shooting")

func stop_shooting():
	shooting = false
	print("Stop Shooting")

func stop_all_actions():
	velocity = Vector2.ZERO
	stop_shooting()
	state = "idle"
	print("Health below 75%, stopping attack loop")

func shortest_angle(from: float, to: float) -> float:
	var diff = fmod(to - from + PI, TAU)
	if diff < 0:
		diff += TAU
	return diff - PI
