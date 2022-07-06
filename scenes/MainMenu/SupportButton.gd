extends Button


func _ready():
	Global.connect("set_buttons_disabled", self, "set_disabled")

func _on_SupportButton_pressed() -> void:
	Global.emit_signal("set_buttons_disabled", true)
	SceneManager.goto_scene("res://scenes/CTA/CTA.tscn")

func set_disabled(is_disabled):
	disabled = is_disabled
