extends Area2D
class_name SettingsIcon

signal entering_settings

export(NodePath) var uto_path
var uto: Uto


func _ready():
	if uto_path:
		uto = get_node(uto_path)


func get_bounds() -> Vector2:
	return $Sprite.texture.get_size() * $Sprite.global_scale


func _on_SettingsIcon_body_entered(body):
	if body is Uto:
		open_settings()


func open_settings():
	emit_signal("entering_settings")
	uto.set_physics_process(false)
	Global.challengeData["utoEnteredSettings"] = true
	SceneManager.goto_scene("res://scenes/settings/SettingsScreen.tscn")
