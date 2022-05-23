extends Node

# Last loaded challenged. Used to restart from a gameoer/victory screen
var last_challenge_path: String
# Current challenge node. It can be null if the current scene is not a challenge
var current_challenge: Challenge

# Registered in Main.gd:_init(), will be populated by this script if running a single scene
var main_node: Main

var last_goto_scene = {
	path = "res://scenes/MainMenu/MainMenu.tscn",
	params = null
}

func _ready():
	if main_node == null:
		# if loading a challenge
		if get_tree().current_scene is Challenge:
			current_challenge = get_tree().current_scene
			last_challenge_path = current_challenge.filename
		# need call_deferred because it's not possible
		# to modify the tree in notification callbacks
		call_deferred("_apply_fix_for_play_scene")


func on_main_node_ready():
	pass


func _apply_fix_for_play_scene():
	""" Needed when starting a specific scene with Play Scene with F6,
	instead of running the whole game"""
	# prepare vars
	var played_scene = get_tree().current_scene
	var root = get_node("/root")
	# load Main.tscn
	main_node = load("res://scenes/Main.tscn").instance()
	root.remove_child(played_scene)
	root.add_child(main_node)
	# reparent played scene under main_node
	main_node.current_scene.get_child(0).queue_free()
	main_node.current_scene.add_child(played_scene)
	last_goto_scene.path = played_scene.filename


func goto_scene(path: String, params = null):
	# print_debug(params)
	main_node.anim.play("show_overlay")
	last_goto_scene = {
		"path": path,
		"params": params
	}
	yield(main_node.anim, "animation_finished")
	call_deferred("_deferred_goto_scene", path, params)



func restart_challenge():
	goto_scene(last_challenge_path)


func _deferred_goto_scene(path: String, params = null):
	# free all nodes in the current scene
	for node in main_node.current_scene.get_children():
		node.queue_free()
		yield(node, "tree_exited")
	# instance the new scene
	var new_scene = _instance_scene_by_path(path)
	if new_scene is Challenge:
		last_challenge_path = path
		current_challenge = new_scene
	else:
		current_challenge = null
	# load it into the SceneTree
	main_node.current_scene.add_child(new_scene)
	main_node.anim.play("hide_overlay")
	if params:
		new_scene.init(params)


func _instance_scene_by_path(path) -> Node:
	var s = load(path)
	if s == null:
		print_debug("Error: path '%s' does not contain any Scene" % path)
		s = load("res://scenes/CTA/CTA.tscn")
	return s.instance()


func reload_current_scene(override_params = null):
	goto_scene(last_goto_scene.path, override_params if override_params else last_goto_scene.params)
