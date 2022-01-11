extends AnimationPlayer

onready var ota = get_node("../OtaPath/OtaPathFollow/Ota")


func _ready():
	pass
#	invert_first_guard_offset()


func invert_first_guard_offset():
	var main: Animation = get_animation("main")
	var track_id = get_track_id(self, "main", "Guard1Path/Guard1PathFollow", "unit_offset")
	for i in main.track_get_key_count(track_id):
		var val = main.track_get_key_value(track_id, i)
		main.track_set_key_value(track_id, i, 1.0 - val)


func get_track_id(ap: AnimationPlayer, anim_name: String, node: String, property: String) -> int:
	var anim: Animation = ap.get_animation(anim_name)
	for i in anim.get_track_count():
		var t = anim.track_get_path(i)
		if node + ":" + property == t:
			return i
	return -1


func remove_ota_animation():
	var main_anim: Animation = get_animation("main")
	var ota_path_follow = ota.get_node("../")
	var animated_node_path_str := str(get_parent().get_path_to(ota_path_follow))
	var track_path = NodePath(animated_node_path_str + ":unit_offset")
	var track_id = main_anim.find_track(track_path)
	if track_id != -1:
		main_anim.remove_track(track_id)
	else:
		print_debug("Track not found for ", track_path)
