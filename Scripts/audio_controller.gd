extends Node2D
@onready var BackMusic = $BackGround
@onready var HeroGun = $HeroGun
@onready var RoboGun = $RoboGun
@onready var Door = $Door
@onready var MaleDeath = $MaleDeath
@onready var FireGun = $FireGun

var background_play = true
# Called when the node enters the scene tree for the first time.

func back_play():
	if AudioController.background_play == true:
		BackMusic.play()

	
func RoboGun_play():
	RoboGun.play()
	
func HeroGun_play():
	HeroGun.play()

func Door_play():
	Door.play()
	
func MaleDeath_play():
	MaleDeath.play()

func FireGun_play():
	FireGun.play()
