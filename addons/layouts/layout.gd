tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("Layout", "res://addons/layouts/layout_manager.gd")


func _exit_tree():
	remove_autoload_singleton("Layout")
