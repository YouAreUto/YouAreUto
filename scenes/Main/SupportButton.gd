extends Button


func _ready() -> void:
	pass


func _on_SupportButton_pressed() -> void:
	SceneManager.goto_scene("res://scenes/cta2/CTA.tscn")
