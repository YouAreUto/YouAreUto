extends Node

var current_challenge: Challenge
# Registered in Main.gd:_init(), null if running a single scene
var main_node: Main


func _ready():
	# get the root node
	var root = get_tree().get_root()
	if main_node == null:
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
	# add it
	root.add_child(main_node)
	# reparent played scene under main_node
	root.remove_child(played_scene)
	main_node.current_scene.get_child(0).queue_free()
	main_node.current_scene.add_child(played_scene)
	

func goto_scene(path: String, params = null):
	main_node.anim.play("show_overlay")
	yield(main_node.anim, "animation_finished")
	call_deferred("_deferred_goto_scene", path, params)


func _deferred_goto_scene(path: String, params = null):
	# free all nodes in the current scene
	for node in main_node.current_scene.get_children():
		node.queue_free()
	# instance the new scene
	var new_scene = _instance_scene_by_path(path)
	# load it into the SceneTree
	main_node.current_scene.add_child(new_scene)
	main_node.anim.play("hide_overlay")
	if params:
		new_scene.init(params)


func _instance_scene_by_path(path):
	var s = load(path)
	if s == null:
		print("Error: path '%s' does not contain any Scene" % path)
		print("Forcing CTA")
		s = load("res://scenes/cta/CTA.tscn")
	return s.instance()
