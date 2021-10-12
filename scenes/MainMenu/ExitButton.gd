extends Button

func _ready() -> void:
	var os = OS.get_name()
	if os == "iOS":
		hide()

func _on_ExitButton_pressed():
	get_tree().quit()
