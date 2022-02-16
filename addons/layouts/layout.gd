tool
extends EditorPlugin


func _enter_tree():
	# enable addon only if binary is not in "release" mode
	if OS.is_debug_build():
		add_autoload_singleton("Layout", "res://addons/layouts/layout_manager.gd")


func _exit_tree():
	if OS.is_debug_build():
		remove_autoload_singleton("Layout")


func add_project_settings():
	ProjectSettings.set("category/property_name", 0)
	var property_info = {
		"name": "category/property_name",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "one,two,three"
	}
	ProjectSettings.add_property_info(property_info)
