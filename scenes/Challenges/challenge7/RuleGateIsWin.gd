extends RayCast2D

onready var active = false

signal rule_gate_is_win_toggled


func get_aligned_rules() -> Array:
	var rule_blocks = []
	position = Vector2()
	for i in range(2):
		position.x = (i + 1) * get_parent().size
		position.y = -5
		var tmp_col
		force_raycast_update()
		var col = get_collider()
		if col is Block:
			tmp_col = col
			position.y = 5
			force_raycast_update()
			col = get_collider()
			if col == tmp_col:
				rule_blocks.append(col)
	return rule_blocks


func is_active():
	var rules = get_aligned_rules()
	if len(rules) == 2 and rules[0].name == "Gate2" and rules[1].name == "Gate3":
		return true
	else:
		return false


func _on_Timer_timeout():
	if active == is_active():
		return
	else:
		active = !active
		emit_signal("rule_gate_is_win_toggled", active)
