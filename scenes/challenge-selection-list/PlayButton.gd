extends Button

export(NodePath) onready var challengeSelectionListPath
onready var challengeSelection = get_node(challengeSelectionListPath)
export(NodePath) onready var challengeSoundPlayerPath
onready var challengeSoundPlayer: AudioStreamPlayer = get_node(challengeSoundPlayerPath)


func startChallenge(challengeNumber):
	if challengeNumber:
		SceneManager.goto_scene(Global.getChallengePath(challengeNumber).intro)


func _on_PlayButton_pressed() -> void:
	var challenge: int = challengeSelection.getSelectedChallenge()
	if challengeSoundPlayer.playing:
		yield(challengeSoundPlayer, "finished")
	if challenge > 0:
		startChallenge(challenge)
	else:
		print("Invalid challenge selected:", challenge)
