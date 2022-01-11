extends VBoxContainer

signal challengeSelected

var scrolling = false
var scrollbar: ScrollBar
var amount_scrolled


func _ready() -> void:
	for item in get_children():
		item.connect("challengeItemPressed", self, "onChallengeItemPressed", [], CONNECT_DEFERRED)
	scrollbar = get_parent().get_v_scrollbar()


func onChallengeItemPressed(challengeNumber):
	if amount_scrolled > 20:
		return
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


func _input(event):
	if scrolling:
		if event is InputEventMouseMotion:
			amount_scrolled += abs(event.relative.y)
	else:
		amount_scrolled = 0


func _on_ScrollContainer_scroll_started():
	scrolling = true


func _on_ScrollContainer_scroll_ended():
	scrolling = false
