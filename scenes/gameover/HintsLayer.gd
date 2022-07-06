extends ColorRect

onready var hint_label := $CenterContainer/VBoxContainer/ScrollContainer/CenterContainer/Label
onready var texture_viewer = $CenterContainer/VBoxContainer/ScrollContainer/CenterContainer/TextureViewer

#
#func _ready():
#	show_full_solution(Hints.challenges_hints[6])


func show_hint(hint_res: HintResource):
	print_debug("show_hint")
	print(hint_res)
	hint_label.text = hint_res.hint
	show()
	hint_label.show()
	texture_viewer.hide()


func show_full_solution(hint_res: HintResource):
	print_debug("full")
	hint_label.show()
	texture_viewer.hide()
	if hint_res.has_full_solution():
		if  hint_res.has_full_solution_images():
			show_solution_images(hint_res.full_solution_images)
		else:
			hint_label.text = hint_res.full_solution
	else:
		print("Full Solution Resource error for ", hint_res)
		assert(false)
	show()


func show_solution_images(images: Array):
	print_debug("image")
	for i in texture_viewer.get_children():
		i.queue_free()
	texture_viewer.show()
	hint_label.hide()
	for image in images:
		var img: Texture = image
		var solution_texture := TextureRect.new()
		solution_texture.expand = true
		solution_texture.texture = image

		var tex_size = solution_texture.texture.get_size()
		var screen_size = Global.vw.size
		var scale_factor = tex_size / screen_size
		scale_factor = max(scale_factor.x, scale_factor.y)
		solution_texture.rect_min_size = Vector2(
			tex_size.x / scale_factor,
			tex_size.y / scale_factor
		)
		solution_texture.update()
		solution_texture.minimum_size_changed()
		solution_texture.modulate.r = 0.94
		solution_texture.modulate.g = 0.94
		solution_texture.modulate.b = 0.94
		var margin = MarginContainer.new()
		var margin_value = 26
		margin.add_constant_override("margin_left", 0)
		margin.add_constant_override("margin_right", margin_value)
		margin.mouse_filter = Control.MOUSE_FILTER_IGNORE

		margin.add_child(solution_texture)
		texture_viewer.add_child(margin)


func _on_GotItButton_pressed():
	hide()
	hint_label.text = ""
