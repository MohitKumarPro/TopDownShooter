extends CharacterBody2D
@onready var officer = $AnimatedSprite2D
const SPEED = 400.0
const JUMP_VELOCITY = -400.0
var life = 3
@onready var hero = $"../HeroBody"
var can_fire = true
var rotation_speed = 5  # radians per second
var timer := 0.0
var run_for_seconds := 3
var running := false
var direction_angel
var State = "Ideal"
var aiming = false
signal officerlife
var i
@onready var AudioController = $"../HeroBody/AudioController"

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	i = rng.randi_range(0, 1)
	look_at(hero.global_position)
	emit_signal("officerlife",life)
func _physics_process(delta: float) -> void:
	if hero.global_position.distance_to(officer.global_position)>=1000 and hero.global_position.distance_to(officer.global_position)<2000 and State != 'death':
		look_at(hero.global_position)
		var direction = hero.global_position - officer.global_position
		direction_angel = (hero.global_position - officer.global_position).angle()
		var new_velocity = direction.normalized() * SPEED
		velocity = new_velocity
		State = 'Running'
		start_running()
	
	if hero.global_position.distance_to(officer.global_position)<1000 and can_fire and State != 'death':
		var direction = hero.global_position - officer.global_position
		State = 'Shoot'
		shoot()
	if running and State != 'death':
		walk_towards(velocity,direction_angel,delta)
		timer += delta
		if timer >= run_for_seconds:
			running = false  # Stop after 5 seconds
			aiming = false

func start_running():
	timer = 0.0
	running = true

func walk_towards(velocity,direction_angel,delta):
	look_at(hero.global_position)
	Robowalk()
	move_and_slide()

func shoot():
	if State == "Shoot":
		if aiming:
			officer.play("shoot")
			await $AnimatedSprite2D.animation_finished
			aiming = false
		else:
			AudioController.RoboGun_play()
			officer.play("shoot")
			var bullet_path = preload("res://Scenes/bulletEnemy.tscn")
			var bullet = bullet_path.instantiate()
			bullet.set_bullet_size(Vector2(1, 1))
			bullet.speed = 3000
			bullet.dir = rotation
			bullet.set_bullet_type("robo")
			bullet.pos = $Marker2DFrontOfficer.global_position
			bullet.rota = global_rotation
			get_parent().add_child(bullet)
			can_fire = false
			await get_tree().create_timer(0.1).timeout
			can_fire = true
	
func _on_area_2_dofficer_area_entered(area: Area2D) -> void:
	if area.name == 'BulletArea':
		life = life - 1
		#emit_signal("officerlife",life)
	if life <= 0:
		State = 'death'
		$Area2Dofficer.queue_free()
		$CollisionShape2D.queue_free()
		$Area2Dofficer/CollisionShape2D.queue_free()
		if i==0:
			officer.play("death")
		else:
			officer.play("death2")
		await get_tree().create_timer(1).timeout
		
		#queue_free()

func Robowalk():
	if State == 'Running':
		officer.play("Run")
