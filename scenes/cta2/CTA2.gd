extends Node2D


func _ready() -> void:
	$Logo.position.x = get_viewport_rect().size.x / 2 + 16


func _on_Donate_pressed() -> void:
	OS.shell_open("https://ko-fi.com/youareuto")


func _on_Website_pressed() -> void:
	OS.shell_open("https://www.youareuto.com")


func _on_UtoShop_pressed() -> void:
	OS.shell_open("https://www.redbubble.com/people/youareuto/og-shop")


func _on_ChallengeSelection_pressed() -> void:
	Global.challengeData = {}
	SceneManager.goto_scene("res://scenes/Main.tscn")
