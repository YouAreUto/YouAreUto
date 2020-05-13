extends Node



func _ready():
	var view_size = get_viewport().get_visible_rect().size
	$Logo.position.x = view_size.x / 2
	$Logo.position.y = view_size.y / 2
#	SceneManager.goto_scene("res://scenes/challenges/challenge2/Challenge2.tscn")


func _on_Button3_pressed() -> void:
	get_tree().quit()


func _on_ChallengeSelectionList_challengeSelected(id) -> void:
	var playBtn = $BG/Buttons/PlayButton
	playBtn.disabled = false
	playBtn.modulate.a = 1

