extends Node

var layouts = [
	Vector2(375, 667), # placeholder, will be replaced by ProjectSettings window size
	Vector2(375, 812),
	Vector2(500, 667), #Vector2(768, 1024)
]


func _ready():
	update_layout_0()


func update_layout_0():
	var start_size = Vector2(
		ProjectSettings.get("display/window/size/test_width"),
		ProjectSettings.get("display/window/size/test_height"))
	if start_size.x == 0 or start_size .y == 0:
		start_size = Vector2(
			ProjectSettings.get("display/window/size/width"),
			ProjectSettings.get("display/window/size/height"))
	layouts[0] = start_size


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_1:
			set_layout(1)
		elif event.scancode == KEY_2:
			set_layout(2)
		elif event.scancode == KEY_0:
			set_layout(0)

		if event.pressed and not event.echo and event.scancode == KEY_QUOTELEFT:
			SceneManager.reload_current_scene()


func set_layout(layout_idx):
	var l = layouts[layout_idx]
	OS.set_window_size(l)
