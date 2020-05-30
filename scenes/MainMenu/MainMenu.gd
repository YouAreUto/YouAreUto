extends Node

onready var tagline = $Tagline
onready var logo = $Logo
onready var anims = $Logo/AnimationPlayer


func _ready() -> void:
	var view_size = get_viewport().get_visible_rect().size
	logo.position.x = view_size.x / 2
	logo.position.y = view_size.y / 2
	
	tagline.rect_position.x = view_size.x / 2 - tagline.rect_size.x / 2
	tagline.rect_position.y = (view_size.y / 2 +
		logo.scale.y * logo.texture.get_size().y / 2 +
		120)
	anims.play("disappear")


func activate_input():
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
