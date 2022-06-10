extends ColorRect

onready var hint_label := $CenterContainer/VBoxContainer/ScrollContainer/CenterContainer/Label


func show_hint(sku: String, hint_type: String):
	if hint_type == "hint":
		hint_label.text = Hints.get_hint(Global.data.currentChallenge)
	elif hint_type == "full_solution":
		hint_label.text = Hints.get_full_solution(Global.data.currentChallenge)
	show()


func _on_GotItButton_pressed():
	hide()
	hint_label.text = ""
