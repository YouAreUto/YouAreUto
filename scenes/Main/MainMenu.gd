extends Node


func _ready() -> void:
	var view_size = get_viewport().get_visible_rect().size
	$Logo.position.x = view_size.x / 2
	$Logo.position.y = view_size.y / 2
