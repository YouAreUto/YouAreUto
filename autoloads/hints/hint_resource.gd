class_name HintResource
extends Resource

export var hint_sku: String # Hint is always a String
export var full_solution_sku: String # Full solution can be a String or an Array of Textures
export var hint: String
export var full_solution: String
export(Array, Texture) var full_solution_images


func has_hint() -> bool:
	if hint_sku != "":
		if hint == "":
			push_warning(str(self) + " does not have a hint String")
			return false
		else:
			return true
	if hint is String and hint != "":
		push_error(str(self) + " hint_sku is missing!")
	return false


func has_full_solution() -> bool:
	if full_solution_sku != "":
		if full_solution == "" and len(full_solution_images) == 0:
			push_warning(str(self) + " does not have a full_solution String or full_solution_images")
			return false
		else:
			return true
	if full_solution is String and full_solution != "":
		push_error(str(self) + " full_solution_sku is missing!")
	return false


func _to_string():
	return "{0} {1}".format([self.resource_name, self.resource_path])


func has_full_solution_images() -> bool:
	return full_solution_images is Array and len(full_solution_images) > 0
