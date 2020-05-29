extends Node

var current_challenge: Challenge
var main_scene: Main


func _ready():
	# get the root node
	var root = get_tree().get_root()
	main_scene = root.get_node("Main")


func goto_scene(path: String, params = null):
	main_scene.anim.play("show_overlay")
	yield(main_scene.anim, "animation_finished")
	call_deferred("_deferred_goto_scene", path, params)


func _deferred_goto_scene(path: String, params = null):
	# free all nodes in the current scene
	for node in main_scene.current_scene.get_children():
		node.queue_free()
	# instance the new scene
	var new_scene = _instance_scene_by_path(path)
	# load it into the SceneTree
	main_scene.current_scene.add_child(new_scene)
	main_scene.anim.play("hide_overlay")
	if params:
		new_scene.init(params)


func _instance_scene_by_path(path):
	var s = load(path)
	if s == null:
		print("Error: path '%s' does not contain any Scene" % path)
		print("Forcing CTA")
		s = load("res://scenes/cta/CTA.tscn")
	return s.instance()
