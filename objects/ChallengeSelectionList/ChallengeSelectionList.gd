extends VBoxContainer

signal challengeSelected

onready var challengeNameAudioPlayer: AudioStreamPlayer = get_parent().get_node("ChallengeNameSound")


func _ready() -> void:
	for item in get_children():
		item.connect("challengeItemPressed", self, "onChallengeItemPressed")


func onChallengeItemPressed(challengeNumber):
	emit_signal("challengeSelected", challengeNumber)
	for i in get_child_count():
		# get the item
		var item = get_child(i)
		# if the item is the one selected
		if i == challengeNumber - 1:
			# show selection graphics
			item.setSelected(true)
		else:
			item.setSelected(false)


func getSelectedChallenge():
	for i in get_child_count():
		# get the item
		var item = get_child(i)
		# if the item is the one selected
		if item.isSelected():
			return item.challengeNumber
	return -1

