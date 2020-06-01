class_name Challenge
extends Node2D

export(AudioStream) var challenge_title_sound

signal victory
signal game_over

var title: String = ""
var audio_player: AudioStreamPlayer


func _init():
	pass


func _ready():
	# required info
	assert(title is String)
	assert(title != "")
	# optional info
	if challenge_title_sound == null:
		print_debug("challenge_title_sound is null. Did you forget to specify a sound?")
	else:
		# init audio node
		audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		audio_player.stream = challenge_title_sound


func completed():
	emit_signal("victory")
	if audio_player:
		audio_player.play()
		yield(audio_player, "finished")
	SceneManager.goto_scene("res://scenes/victory/VictoryScreen.tscn")


func _on_challenge_completed():
	# override this in your challenge if needed
	pass


func failed():
	emit_signal("game_over")
	SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn")

# signal callbacks

func _on_uto_touched_gameover_area():
	failed()


func _on_uto_touched_victory_area():
	completed()

