extends Area2D
class_name SettingsIcon
tool

func _ready():
	if Engine.editor_hint:
		return


func get_bounds() -> Vector2:
	return $Sprite.texture.get_size() * $Sprite.global_scale
