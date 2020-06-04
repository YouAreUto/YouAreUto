extends Node2D
tool

export var trigger = false

onready var text: Sprite = get_parent()
onready var debug_time = get_node("../../../Challenge3").debug_time
onready var hour_spr = get_node("ch5-hour-0")


func _ready() -> void:
	var current_hour = OS.get_time().hour
	var current_minute = OS.get_time().minute

	if debug_time.enabled:
		current_hour = debug_time.hour
		current_minute = debug_time.minute
	setLayout(current_hour, current_minute)


func setLayout(current_hour, current_minute):
	var separation = 0
	var max_width = text.texture.get_size().x * text.scale.x

	if 58 <= current_minute and current_minute < 60:
		current_hour = current_hour + 1

	set_texture_by_hour($"ch5-hour-6", current_hour % 12)

	for i in range(13):
		# skip node "ch5-hour-0"
		if i == 0:
			continue
		# skip node "ch5-hour-6"
		if i == 6:
			continue
		var node = get_node("ch5-hour-{}".format([i], "{}"))
		var dcn = i - 6  # distance from center node
		var hour = current_hour + dcn

		if hour <= 0:
			hour += 12
		if hour > 12:
			hour = hour % 12

		set_texture_by_hour(node, hour)
		# print(node.name, " / ", hour)
	# force first node to be equal to last node
	set_texture_by_hour($"ch5-hour-0", (current_hour + 6) % 12)

	if current_hour == 3 or current_hour == 15:
		$CollisionCenter/CollisionShape2D.disabled = true


func set_texture_by_hour(spr, hour):
	var textures_path = hour_spr.texture.resource_path.get_base_dir()
	var hour_spr_base_name = "ch5-hour-{}"
	var texture_name
	if hour == 0:
		texture_name = hour_spr_base_name.format([12], "{}") + ".png"
	elif 0 < hour and hour <= 12:
		texture_name = hour_spr_base_name.format([hour], "{}") + ".png"
	else:
		print("ERROR while setting hour texture ", hour)
	# load the new texture
	var newTexture = load(textures_path + '/' + texture_name)
	spr.texture = newTexture
