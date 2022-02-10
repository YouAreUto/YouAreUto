extends Area2D
class_name Pawn
tool

export(int) var size setget set_size
export(Texture) var texture setget set_texture


func set_texture(val):
	texture = val
	var sprite: Sprite = get_node_or_null("Sprite")
	if sprite:
		sprite.texture = texture


func set_size(val):
	size = val
	var sprite: Sprite = get_node_or_null("Sprite")
	if sprite and sprite.texture:
		var tex_size = sprite.texture.get_size()
		sprite.scale = Vector2.ONE * size / tex_size
		var collision_shape: CollisionShape2D = get_node_or_null("CollisionShape2D")
		if collision_shape:
			collision_shape.shape.radius  = size * 0.4
	elif sprite:
		sprite.scale = Vector2.ONE
	if scale != Vector2.ONE:
		print_debug("Root node scale should be set to (1,1)")
