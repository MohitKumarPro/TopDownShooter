# Door.gd
extends Node2D

@onready var door1 = $BasicFurniture0000s0003s0000Side
@onready var door2 = $BasicFurniture0000s0003s0000Side2
@onready var door3 = $HudMinimap2
@onready var door4 = $HudMinimap
var start = 'donothing'
var i
func _ready():
	i=0
	door3.visible = false
	door4.visible = false
	

	

func _process(delta):
	if start=='broke':
		door1.rotation = rotate_toward(door1.rotation, -45, deg_to_rad(80) * delta*2)
		door2.rotation = rotate_toward(door2.rotation, -30, deg_to_rad(80) * delta*2)
		door1.position.y -= 20
		door2.position.y -= 20
	if start=='fall':
		door3.visible = true
		door4.visible = true
		door1.visible = false
		door2.visible = false
		door3.position.y -= 20
		door4.position.y -= 20
		await get_tree().create_timer(0.1).timeout
		start = 'gone'
		$DoorArea2D.monitoring = false
		$DoorArea2D/CollisionShape2D.disabled = true
# To trigger: call $Door.throw_door() from another script or signal


func _on_door_area_2d_area_entered(area: Area2D) -> void:
	i=i+1
	if area.name=='BulletArea' and i>50:
		start = 'broke'
		await get_tree().create_timer(0.3).timeout
		start = 'fall'
		
