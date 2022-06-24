class_name HintResource
extends Resource

export var hint: String
export var full_solution: String
export(Array, Texture) var full_solution_images


func has_hint() -> bool:
	return hint != ""


func has_full_solution() -> bool:
	return full_solution != ""


func has_full_solution_images() -> bool:
	return full_solution_images is Array and len(full_solution_images) > 0
