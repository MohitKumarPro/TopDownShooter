extends Node2D
@onready var BackMusic = $BackGround
@onready var HeroGun = $HeroGun
@onready var RoboGun = $RoboGun
var background_play = true
# Called when the node enters the scene tree for the first time.

func back_play():
	if AudioController.background_play == true:
		BackMusic.play()

	
func RoboGun_play():
	RoboGun.play()
	
func HeroGun_play():
	HeroGun.play()
