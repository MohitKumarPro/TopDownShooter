extends CharacterBody2D
@onready var Robo = $AnimatedSprite2D
const SPEED = 400.0
const JUMP_VELOCITY = -400.0
var life = 50
@onready var hero = $"../HeroBody"
var can_fire = true
var rotation_speed = 5  # radians per second
var timer := 0.0
var run_for_seconds := 3
var running := false
var direction_angel
var State = "Ideal"
var aiming = false
signal Robolife
@onready var AudioController = $"../AudioController"
func _ready() -> void:
	emit_signal("Robolife",life)
func _physics_process(delta: float) -> void:
	if hero.global_position.distance_to(Robo.global_position)>=800:
		var direction = hero.global_position - Robo.global_position
		direction_angel = (hero.global_position - Robo.global_position).angle()
		var new_velocity = direction.normalized() * SPEED
		velocity = new_velocity
		State = 'Running'
		start_running()
	
	if hero.global_position.distance_to(Robo.global_position)<700 and can_fire:
		var direction = hero.global_position - Robo.global_position
		direction_angel = (hero.global_position - Robo.global_position).angle()
		rotation = lerp_angle(rotation, direction_angel, rotation_speed * delta)
		State = 'Shoot'
		shoot()
	if running:
		walk_towards(velocity,direction_angel,delta)
		timer += delta
		if timer >= run_for_seconds:
			running = false  # Stop after 5 seconds
			aiming = false

func start_running():
	timer = 0.0
	running = true

func walk_towards(velocity,direction_angel,delta):
	rotation = lerp_angle(rotation, direction_angel, rotation_speed * delta)
	Robowalk()
	move_and_slide()

func shoot():
	if State == "Shoot":
		if aiming:
			Robo.play("AimGun")
			await $AnimatedSprite2D.animation_finished
			aiming = false
		else:
			AudioController.RoboGun_play()
			Robo.play("ShootGun")
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
	
	
func _on_enemy_robo_area_area_entered(area: Area2D) -> void:
	if area.name == 'BulletArea':
		life = life - 1
		emit_signal("Robolife",life)
	if life <= 0:
		queue_free()

func Robowalk():
	if State == 'Running':
		Robo.play("Run")
