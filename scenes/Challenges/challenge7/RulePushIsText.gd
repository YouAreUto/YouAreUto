extends RayCast2D

onready var text_is_push = true
onready var text_is_bridge = false

signal rule_text_is_push_toggled
signal rule_text_is_bridge_toggled


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
			if (col in rule_blocks) == false:
				rule_blocks.append(col)
	return rule_blocks


func is_text_is_push_active():
	var rules = get_aligned_rules()
	if rules.size() == 2 and rules[0] and rules[1] and rules[0].name == "Text2" and rules[1].name == "Text3":
		return true
	else:
		return false


func is_text_is_bridge_active():
	var rules = get_aligned_rules()
	if len(rules) == 2 and rules[0] and rules[1] and rules[0].name == "Text2" and rules[1].name == "Bridge":
		return true
	else:
		return false


func _on_Timer_timeout():
	if text_is_push == is_text_is_push_active():
		pass
	else:
		text_is_push = !text_is_push
		emit_signal("rule_text_is_push_toggled", text_is_push)

	if text_is_bridge == is_text_is_bridge_active():
		return
	else:
		text_is_bridge = !text_is_bridge
		emit_signal("rule_text_is_bridge_toggled", text_is_bridge)
