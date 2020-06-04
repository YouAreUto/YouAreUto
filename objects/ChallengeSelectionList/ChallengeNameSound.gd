extends AudioStreamPlayer


var challenge_sounds = [
	"res://assets/sounds/C1.ogg",
	"res://assets/sounds/C2.ogg",
	"res://assets/sounds/C3.ogg",
	"res://assets/sounds/C4.ogg",
	"res://assets/sounds/C5.ogg",
]

func play_audio_for_challenge(challenge_id: int):
	stream = load(challenge_sounds[challenge_id])
	play()


func _on_ChallengeSelectionList_challengeSelected(challenge_id) -> void:
	play_audio_for_challenge(challenge_id - 1)
