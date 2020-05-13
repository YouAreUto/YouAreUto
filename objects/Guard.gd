extends Node2D
class_name Guard

func get_size():
	return $Icon.texture.get_size() * $Icon.scale * scale
