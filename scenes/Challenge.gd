class_name Challenge
extends Node2D

export(AudioStream) var challenge_title_sound

signal victory
signal game_over

var title: String = ""
var audio_player: AudioStreamPlayer
var conf := {
	"victory_and_gameover_screen": {
		# legacy behaviour: keeps compatibility with old challenges.
		# Leave it to false if you are creating new challenges.
		"use_legacy_behaviour": false
	}
}

func _init():
	pass


func _ready():
	# required info
	assert(title is String)
	assert(title != "")
	# optional info
	if challenge_title_sound == null:
		print_debug("challenge_title_sound is null. Don't worry, we will create an audio for this challenge.")
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
	SceneManager.goto_scene("res://scenes/victory/VictoryScreen.tscn", { 
		"use_legacy_code": conf.get("victory_and_gameover_screen").get("use_legacy_behaviour")
	})


func failed():
	emit_signal("game_over")
	SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn", { 
		"use_legacy_code": conf.get("victory_and_gameover_screen").get("use_legacy_behaviour")
	})


func _on_challenge_completed():
	# override this in your challenge if needed
	pass


# signal callbacks

func _on_uto_touched_gameover_area():
	failed()


func _on_uto_touched_victory_area():
	completed()

