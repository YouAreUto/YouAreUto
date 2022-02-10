extends KinematicBody2D
class_name Block
tool

export(Texture) var texture setget set_texture
export(int) var size = 100 setget set_size
export(bool) var pushable = true


func set_pushable(val):
	pushable = val
	$PushBehaviour.active = val


func set_texture(val):
	texture = val
	var sprite = get_node_or_null("Sprite")
	if sprite:
		sprite.texture = texture
		set_size(size)


func set_size(val):
	size = val
	var sprite = get_node_or_null("Sprite")
	if sprite and sprite.texture:
		sprite.scale = Vector2.ONE * size / sprite.texture.get_size().x
	var collision: CollisionShape2D = get_node_or_null("CollisionShape2D")
	if collision:
		var shape: RectangleShape2D = collision.shape
		shape.extents = size / 2 * Vector2.ONE
		$Area2D/CollisionShape2D.shape.extents = shape.extents + 10 * Vector2.ONE
