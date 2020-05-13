extends Node2D


func getSize() -> Vector2:
	return $Sprite.texture.get_size() * scale
