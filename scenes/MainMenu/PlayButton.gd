extends Button

export(NodePath) onready var challengeSelectionListPath
onready var challengeSelection = get_node(challengeSelectionListPath)
export(NodePath) onready var challengeSoundPlayerPath
onready var challengeSoundPlayer: AudioStreamPlayer = get_node(challengeSoundPlayerPath)


func _ready():
	Global.connect("set_buttons_disabled", self, "set_disabled")

func startChallenge(challengeNumber):
	if challengeNumber:
		SceneManager.goto_scene(Global.getChallengePath(challengeNumber).intro)


func _on_PlayButton_pressed() -> void:
	Global.emit_signal("set_buttons_disabled", true)
	get_parent().get_node("SupportButton")
	var challenge: int = challengeSelection.getSelectedChallenge()
	if challengeSoundPlayer.playing:
		yield(challengeSoundPlayer, "finished")
	if challenge > 0:
		startChallenge(challenge)
	else:
		print_debug("Invalid challenge selected:", challenge)


func _on_ChallengeSelectionList_challengeSelected(_challenge_id) -> void:
	modulate.a = 1
	disabled = false

func set_disabled(is_disabled):
	disabled = is_disabled
