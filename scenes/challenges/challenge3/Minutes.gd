extends Node2D

onready var centerNode := $"ch5-min-3"
onready var debug_time = get_node("../../../Challenge3").debug_time

func _ready() -> void:
	var current_minutes = OS.get_time().minute
	if debug_time.enabled:
		current_minutes = debug_time.minute
	setLayout(current_minutes)


func setLayout(current_minutes):
	var child_nodes = get_children()

	for i in range(7):
		var minute_node = get_child(i)
		#minute_node.texture = load(get_texture_path_by_minutes(current_minutes))

		var minute_iter = (current_minutes + 10*(i - 3))
		if minute_iter < 0:
			minute_iter += 60
		if minute_iter >= 60:
			minute_iter -= 60
		minute_node.texture = load(get_texture_path_by_minutes(minute_iter))
		# if it is the center node
		if i == 3:
			centerNode.texture = load(get_texture_path_by_minutes(minute_iter))
			continue
		# if it is the last node
		if i == 6:
			# set the same texture as the first node
			minute_node.texture = $"ch5-min-0".texture

	if (28 <= current_minutes and current_minutes < 38):
		$CollisionCenter/CollisionShape2D.disabled = true


func get_texture_path_by_minutes(minutes: int) -> String:
	var texture_folder = centerNode.texture.resource_path.get_base_dir()
	var texture_name = ""
	# 9:53 copre da 9:48:00 a 9:57:59
	if 8 <= minutes and minutes < 18:
		texture_name = "ch5-min-13.png"
	elif 18 <= minutes and minutes < 28:
		texture_name = "ch5-min-23.png"
	elif 28 <= minutes and minutes < 38:
		texture_name = "ch5-min-33.png"
	elif 38 <= minutes and minutes < 48:
		texture_name = "ch5-min-43.png"
	elif 48 <= minutes and minutes < 58:
		texture_name = "ch5-min-53.png"
	elif (58 <= minutes and minutes < 60) or (0 <= minutes and minutes < 8):
		texture_name = "ch5-min-03.png"
	return texture_folder + "/" + texture_name


func set_texture_by_minute(spr, minute):
	if 0 < minute and minute <= 60:
		var textures_path = get_child(0).texture.resource_path.get_base_dir()
		var spr_base_name = "ch5-min-{}"
		var texture_name = spr_base_name.format([minute], "{}") + ".png"
		# load the new texture
		var newTexture = load(textures_path + '/' + texture_name)
		spr.texture = newTexture
		breakpoint
