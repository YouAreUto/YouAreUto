extends Challenge


onready var uto: Uto = $UTO


func _init():
	title = "Uto Is Tribute"
	Global.data["currentChallenge"] = 7


func _ready():
	if Global.challengeData.get("utoEnteredSettings"):
		restore_challenge_state()


func init(params: Dictionary):
	pass


func failed():
	.failed()
	stop_animations()


func stop_animations():
	for guard in get_tree().get_nodes_in_group("guards"):
		guard.set_physics_process(false)
		guard.get_node("GuardCh7").set_physics_process(false)


func set_gate_is_win(val):
	$Gate.monitoring = val


func disable_uto_collisions():
	uto.set_collision_mask_bit(0, false)
	uto.set_collision_layer_bit(0, false)
	uto.set_collision_layer_bit(1, false)


func save_challenge_state():
	Global.challengeData = {
		"utoEnteredSettings": true
	}
	for block in get_tree().get_nodes_in_group("blocks"):
		if Global.challengeData.has(block.name):
			printerr("Block ", block.name, " already in challengeData")
			return
		Global.challengeData[block.name] = block.global_position


func restore_challenge_state():
	for block in get_tree().get_nodes_in_group("blocks"):
		if Global.challengeData.has(block.name):
			block.global_position = Global.challengeData[block.name]


func _on_SettingsIcon_entering_settings():
	stop_animations()
	save_challenge_state()


func _on_Gate_body_entered(body):
	if body is Uto:
		stop_animations()
		uto.set_physics_process(false)
		self.completed()


func _on_RuleGaurdIsDeath_rule_guard_is_death_toggled(rule_is_active):
	print("Guard is death: ", rule_is_active)
	for guard in get_tree().get_nodes_in_group("guards"):
		guard.guard_kills_uto = rule_is_active


func _on_RuleGateIsWin_rule_gate_is_win_toggled(val):
	print("Gate is win: ", val)
	set_gate_is_win(val)


func _on_RuleTextIsPush_rule_text_is_bridge_toggled(is_bridge):
	print("Text is bridge: ", is_bridge)
	# enable collision detection for uto
	$Gate.set_collision_mask_bit(3, true)
	uto.set_collision_layer_bit(3, true)


func _on_RuleTextIsPush_rule_text_is_push_toggled(is_push):
	if is_push == false:
		disable_uto_collisions()
	print("Text is push: ", is_push)
	for guard in get_tree().get_nodes_in_group("guards"):
		guard.get_node("GuardCh7").collide_with_blocks = false
	for block in get_tree().get_nodes_in_group("blocks"):
		block.set_pushable(is_push)


var blocks_on_game_over_area = []
func _on_GateGameOverArea_body_entered(body):
	if body is Block and body.name != "InvisibleBlock":
		blocks_on_game_over_area.append(body)
	if blocks_on_game_over_area.size() < 2:
		return
	if blocks_on_game_over_area[0].name == "Guard1" and blocks_on_game_over_area[1].name == "Guard2" or blocks_on_game_over_area[0].name == "Guard2" and blocks_on_game_over_area[1].name == "Guard1":
		print("Disabling gate gameover area")
		$BG/GateGameOverArea.queue_free()
