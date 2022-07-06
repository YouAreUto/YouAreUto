extends Node2D


func _ready() -> void:
	$Logo.position.x = get_viewport_rect().size.x / 2 + 16
	Global.connect("set_buttons_disabled", self, "set_all_disabled")

func _on_Donate_pressed() -> void:
	OS.shell_open("https://ko-fi.com/youareuto")
	Global.emit_signal("set_buttons_disabled", true)

func _on_Website_pressed() -> void:
	OS.shell_open("https://www.youareuto.com")
	Global.emit_signal("set_buttons_disabled", true)

func _on_UtoShop_pressed() -> void:
	OS.shell_open("https://www.redbubble.com/people/youareuto/og-shop")
	Global.emit_signal("set_buttons_disabled", true)

func _on_ChallengeSelection_pressed() -> void:
	Global.challengeData = {}
	SceneManager.goto_scene("res://scenes/MainMenu/MainMenu.tscn")
	Global.emit_signal("set_buttons_disabled", true)
	
func set_all_disabled(is_disabled):
	$CanvasLayer/VBoxContainer/UtoShop.disabled = is_disabled
	$CanvasLayer/VBoxContainer/Website.disabled = is_disabled
	$CanvasLayer/VBoxContainer/ChallengeSelection.disabled = is_disabled
