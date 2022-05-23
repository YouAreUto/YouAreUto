tool
extends EditorPlugin


func _enter_tree():
	# enable addon only if binary is not in "release" mode
	if OS.is_debug_build():
		add_autoload_singleton("Layout", "res://addons/layouts/layout_manager.gd")


func _exit_tree():
	if OS.is_debug_build():
		remove_autoload_singleton("Layout")
