extends Button

export var on = true


func toggle():
	on = !on
	updateText()


func setStatus(status):
	if status == true:
		on = true
	else:
		on = false
	updateText()


func updateText():
	if on:
		text = "ON"
	else:
		text = "OFF"


func _on_ToggleButton_button_down():
	toggle()
