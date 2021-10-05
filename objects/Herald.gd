extends Node2D

func kill():
	visible = false
	$Area2D.visible = false
	$SwordCutSound.play()
