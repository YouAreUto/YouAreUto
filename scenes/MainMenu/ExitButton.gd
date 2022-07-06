extends Button

func _ready() -> void:
	var os = OS.get_name()
	if os == "iOS":
		hide()
	Global.connect("set_buttons_disabled", self, "set_disabled")
	
func _on_ExitButton_pressed():
	get_tree().quit()

func set_disabled(is_disabled):
	disabled = is_disabled
