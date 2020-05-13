extends Node


onready var uto: Uto = get_parent()
var uto_is_covered = true


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	uto_is_covered = false
	for area in uto.get_node("HitArea").get_overlapping_areas():
		if area.is_in_group("umbrella"):
			uto_is_covered = true
	if uto_is_covered:
		pass
	else:
		uto.killUto()
		set_process(false)


func _on_Timer_timeout() -> void:
	set_process(true)
