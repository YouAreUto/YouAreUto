class_name Challenge
extends Node

signal victory
signal game_over

var title: String = ""


func _init():
	SceneManager.current_challenge = self


func _ready():
	assert(title is String)
	assert(title != "")


func _on_uto_gameover_area_touched():
	emit_signal("game_over")
	SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn")


func _on_uto_victory_area_touched():
	emit_signal("victory")
	SceneManager.goto_scene("res://scenes/victory/VictoryScreen.tscn")
