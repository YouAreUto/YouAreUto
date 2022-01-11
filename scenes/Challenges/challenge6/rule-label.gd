extends Label


func _ready():
	# align and fit horizontally
	fit_horizontal_space()
	call_deferred("center_align")


func fit_horizontal_space():
	if rect_size.x > Global.vw.size.x:
		rect_scale.x = 0.95 * Global.vw.size.x / rect_size.x
		rect_scale.y = rect_scale.x


func center_align():
	rect_position.x = Global.vw.size.x / 2 - rect_size.x * rect_scale.x / 2


func set_visible(val):
	visible = val
	$StaticBody2D/CollisionShape2D.disabled = !val
