extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hero_body_herolife(herolife) -> void:
	$Label.text = str(herolife) 


func _on_enemy_robolife(robolife) -> void:
	$Label2.text = str(robolife) 
