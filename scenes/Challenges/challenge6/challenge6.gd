extends Challenge

onready var settings_icon := $SettingsIcon
onready var captain := find_node("Captain")
onready var poet_path = $PoetPath
onready var servant_path = $ServantPath
onready var rule_poet = get_node("Texts/Control/Poet")
onready var rule_servant = get_node("Texts/Control/Servant")
onready var rule_guard = get_node("Texts/Control/Guard")
onready var uto = $UTO
onready var anims := $AnimationPlayer
onready var guard1 = $Guard1Path/Guard1PathFollow/Guard
onready var guard1_path: Path2D = $Guard1Path
onready var guard2_path: Path2D = $Guard2Path

var vs: Vector2 # viewport size
var margin = Vector2(32, 32)
var poet_top_y
var poet_bot_y
var pawn_size = 130
var half_pawn_size = pawn_size / 2


func _init():
	title = "White Circle"
	Global.data["currentChallenge"] = 6


func _ready():
	# if we are starting the challenge
	if !Global.challengeData.has("utoEnteredSettings"):
		Global.challengeData = {
			"active_rules": []
		}
	vs = Global.vw.size
	get_viewport().connect("size_changed", self, "on_resize")
	set_layout()
	# activate saved rules
	for rule in Global.challengeData.get("active_rules", []):
		$ChallengeLogic.add_rule(rule)
	# remove mockup node
	if get_node_or_null("M1"):
		$M1.queue_free()
	call_deferred("deferred_set_uto_pos")


func deferred_set_uto_pos():
	if Global.challengeData.has("utoEnteredSettings"):
		uto.global_position = $SettingsIcon/UtoRespawnPosition.global_position
		uto.global_position.y -= 100
		Global.challengeData.erase("utoEnteredSettings")


func on_resize():
	pass


func set_layout(_val = false):
	var guard_bottom_y = vs.y - half_pawn_size - half_pawn_size * 2
	poet_top_y = 280
	poet_bot_y = poet_top_y + 320
	# left guard
	var guard_left = half_pawn_size
	var guard_right = vs.x - half_pawn_size
	var guard_top = guard_bottom_y - 500
	var captain_path_length = guard_right - guard_left
	guard1_path.curve.clear_points()
	guard1_path.curve.add_point(Vector2(
		guard_left, guard_bottom_y
	))
	guard1_path.curve.add_point(Vector2(
		vs.x / 2 + 10, guard_bottom_y
	))
	guard1_path.curve.add_point(Vector2(
		vs.x / 2 + 10, guard_top
	))
	guard1_path.curve.add_point(Vector2(
		guard_right, guard_top
	))
	# guard right
	guard2_path.curve.clear_points()
	guard2_path.curve.add_point(Vector2(
		guard_right, guard_bottom_y
	))
	guard2_path.curve.add_point(Vector2(
		vs.x / 2 - 10, guard_bottom_y
	))
	guard2_path.curve.add_point(Vector2(
		vs.x / 2 - 10, guard_top
	))
	guard2_path.curve.add_point(Vector2(
		guard_left, guard_top
	))
	# captain
	var captain_path: Path2D = $CaptainPath
	var captain_y = vs.y - half_pawn_size
	captain_path.curve.clear_points()
	captain_path.curve.add_point(Vector2(
		guard_left, captain_y
	))
	captain_path.curve.add_point(Vector2(
		vs.x / 2, captain_y
	))
	captain_path.curve.add_point(Vector2(
		vs.x / 2, captain_y + (guard1_path.curve.get_baked_length() - captain_path_length) / 2
	))
	captain_path.curve.add_point(Vector2(
		vs.x / 2, captain_y
	))
	captain_path.curve.add_point(Vector2(
		guard_right, captain_y
	))
	# poet path
	poet_path.curve.clear_points()
	poet_path.curve.add_point(Vector2(
		vs.x + 150,
		poet_top_y
	))
	poet_path.curve.add_point(Vector2(
		vs.x - half_pawn_size - 220,
		poet_top_y
	))
	poet_path.curve.add_point(Vector2(
		vs.x - half_pawn_size - 220,
		poet_bot_y
	))
	poet_path.curve.add_point(Vector2(
		vs.x + 150,
		poet_bot_y
	))
	# servant path
	servant_path.curve.clear_points()
	servant_path.curve.add_point(Vector2(
		-150,
		poet_bot_y
	))
	servant_path.curve.add_point(Vector2(
		half_pawn_size + 250,
		poet_bot_y
	))
	servant_path.curve.add_point(Vector2(
		half_pawn_size + 250,
		poet_top_y
	))
	servant_path.curve.add_point(Vector2(
		-150,
		poet_top_y
	))
	# settings icon
	settings_icon.position.x = vs.x - 80
	settings_icon.position.y = guard_top + (guard_bottom_y - guard_top) / 2 + 50
	# uto
	if !Global.challengeData.has("utoEnteredSettings"):
		uto.position = settings_icon.global_position
		uto.position.x = 90
	else:
		uto.global_position = $SettingsIcon/UtoRespawnPosition.global_position


func shrink_upper_pawns_path():
	# poet path
	poet_path.curve.clear_points()
	poet_path.curve.add_point(Vector2(
		vs.x - half_pawn_size,
		poet_top_y
	))
	poet_path.curve.add_point(Vector2(
		vs.x - half_pawn_size - 200,
		poet_top_y
	))
	poet_path.curve.add_point(Vector2(
		vs.x - half_pawn_size - 200,
		poet_bot_y
	))
	poet_path.curve.add_point(Vector2(
		vs.x - half_pawn_size,
		poet_bot_y
	))
	# servant path
	servant_path.curve.clear_points()
	servant_path.curve.add_point(Vector2(
		half_pawn_size,
		poet_bot_y
	))
	servant_path.curve.add_point(Vector2(
		half_pawn_size + 200,
		poet_bot_y
	))
	servant_path.curve.add_point(Vector2(
		half_pawn_size + 200,
		poet_top_y
	))
	servant_path.curve.add_point(Vector2(
		half_pawn_size,
		poet_top_y
	))


func correct_rules_order():
	var r = Global.challengeData.active_rules
	return (len(r) == 4) and (r[2] == "ota" and r[3] == "poet")


func on_rules_changed(new_rule_key):
	if not new_rule_key in Global.challengeData.active_rules:
		Global.challengeData.active_rules.append(new_rule_key)
	if new_rule_key == "ota":
		$ChallengeLogic.call_deferred("ota_start_following_uto")
	if new_rule_key == "poet":
		uto.position.x = vs.x - 140
		uto.position.y = get_lowest_rule_y_pos() + 100
		var ota: Ota = get_node_or_null("Ota")
		if ota:
			ota.position = uto.position
			ota.position.x += 60
			ota.position.y += 90
	if Global.challengeData.active_rules.has('ota') and \
	   Global.challengeData.active_rules.has('guard'):
		for g in get_tree().get_nodes_in_group("guards"):
			var outline = g.get_node("Outline")
			if outline.visible:
				continue
			outline.show()
			g.get_node("Icon").texture = load("res://assets/sprites/characters/char-guard-cut.png")
			if g.is_connected("uto_overlapped", self, "_on_Guard_uto_overlapped"):
				g.disconnect("uto_overlapped", self, "_on_Guard_uto_overlapped")
	if correct_rules_order():
		puzzle_enable_victory()
	# if words are barriers
	if rule_poet.visible:
		update_paths_to_not_cross_barriers()
		for g in get_tree().get_nodes_in_group("guards"):
			g.get_node("OtaDetector").shrink()
		if get_lowest_rule_y_pos() > uto.position.y - 50:
			uto.position.y = get_lowest_rule_y_pos() + 70
	# if guards need to detect ota
	if rule_guard.visible:
		for g in get_tree().get_nodes_in_group("guards"):
			g.get_node("OtaDetector").enable_collisions()


func update_paths_to_not_cross_barriers():
	if rule_servant.visible:
		# update guard paths to barely touch the "you are definitely lost" text
		var new_points = [guard1_path.curve.get_point_position(0), guard1_path.curve.get_point_position(1)]
		new_points[0].y = rule_servant.rect_global_position.y - half_pawn_size
		new_points[1].y = rule_servant.rect_global_position.y - half_pawn_size
		guard1_path.curve.set_point_position(0, new_points[0])
		guard1_path.curve.set_point_position(1, new_points[1])
		new_points = [guard2_path.curve.get_point_position(0), guard2_path.curve.get_point_position(1)]
		new_points[0].y = rule_servant.rect_global_position.y - half_pawn_size
		new_points[1].y = rule_servant.rect_global_position.y - half_pawn_size
		guard2_path.curve.set_point_position(0, new_points[0])
		guard2_path.curve.set_point_position(1, new_points[1])
	var top_rule_y_pos = $Texts/Control/YouAreUto.rect_global_position.y
	# poet
	var new_points = [poet_path.curve.get_point_position(2), poet_path.curve.get_point_position(3)]
	new_points[0].y = top_rule_y_pos - half_pawn_size
	new_points[1].y = top_rule_y_pos - half_pawn_size
	poet_path.curve.set_point_position(2, new_points[0])
	poet_path.curve.set_point_position(3, new_points[1])
	# servant
	new_points = [servant_path.curve.get_point_position(0), servant_path.curve.get_point_position(1)]
	new_points[0].y = top_rule_y_pos - half_pawn_size
	new_points[1].y = top_rule_y_pos - half_pawn_size
	servant_path.curve.set_point_position(0, new_points[0])
	servant_path.curve.set_point_position(1, new_points[1])
	# guards
	var last_rule_bottom_y = get_lowest_rule_y_pos()
#	print(last_rule_bottom_y > guard1_path.curve.get_point_position(2).y - 50)
	if last_rule_bottom_y > guard1_path.curve.get_point_position(2).y - 50:
		# guard 1
		new_points = []
		for i in guard1_path.curve.get_point_count():
			new_points.append(guard1_path.curve.get_point_position(i))
		new_points[2].y = last_rule_bottom_y + half_pawn_size
		new_points[3].y = last_rule_bottom_y + half_pawn_size
#		new_points[0].x -= 100
		new_points[3].x -= 100
		for i in guard1_path.curve.get_point_count():
			guard1_path.curve.set_point_position(i, new_points[i])
		# guard 2
		new_points = []
		for i in guard2_path.curve.get_point_count():
			new_points.append(guard2_path.curve.get_point_position(i))
		new_points[2].y = last_rule_bottom_y + half_pawn_size
		new_points[3].y = last_rule_bottom_y + half_pawn_size
#		guard2_path.curve.get_point_position(0).x -= 300
		new_points[3].x += 100
#		new_points[0].x += 100
		for i in guard2_path.curve.get_point_count():
			guard2_path.curve.set_point_position(i, new_points[i])
		if anims.is_playing():
			var cur_anim = anims.current_animation
			anims.stop()
			anims.play(cur_anim)


func update_guards_path_to_not_overlap_text():
	vs = get_viewport_rect().size
	var guard_half_size = guard1.get_size().x / 2
	var guard_bottom_y = $Texts/Control/Servant.rect_position.y - guard_half_size
	var guard_top_y = get_lowest_rule_y_pos() + guard_half_size
	# paths
	guard1_path.curve.clear_points()
	guard1_path.curve.add_point(Vector2(
		-100, guard_bottom_y
	))
	guard1_path.curve.add_point(Vector2(
		vs.x / 2, guard_bottom_y
	))
	guard1_path.curve.add_point(Vector2(
		vs.x / 2, guard_top_y
	))
	guard1_path.curve.add_point(Vector2(
		vs.x + 100, guard_top_y
	))
	# guard right
	guard2_path.curve.clear_points()
	guard2_path.curve.add_point(Vector2(
		vs.x + 100,
		guard_bottom_y
	))
	guard2_path.curve.add_point(Vector2(
		vs.x / 2,
		guard_bottom_y
	))
	guard2_path.curve.add_point(Vector2(
		vs.x / 2, guard_top_y
	))
	guard2_path.curve.add_point(Vector2(
		-100, guard_top_y
	))
	anims.stop()
	anims.play("victory-paths")
	# make it easier to win
	for guard in get_tree().get_nodes_in_group("guards"):
		guard.get_node("OtaDetector").shrink()


func get_lowest_rule_y_pos() -> int:
	var lowest_y = 0
	for el in $Texts/Control.get_children():
		var rule_name = el.name
		var rule_y = el.rect_global_position.y
		var rule_height = el.rect_size.y
		if rule_name == "Servant" or !el.visible:
			continue
		lowest_y = max(lowest_y, rule_y + rule_height)
		pass
	return lowest_y


func puzzle_enable_victory():
	call_deferred("update_guards_path_to_not_overlap_text")
	$AnimationPlayer.invert_first_guard_offset()
	$CaptainPath/CaptainPathFollow/Captain/VictoryArea.monitoring = true
	uto.position.x = vs.x / 2
	uto.position.y = get_lowest_rule_y_pos() + half_pawn_size
	uto.cancel_movement()


func on_victory():
	get_node("AnimationPlayer").stop()
	get_node("TopPawnsAnimations").stop()
	uto.set_physics_process(false)
	self.completed()


func _on_VictoryArea_body_entered(body):
	if body is Uto and correct_rules_order():
		on_victory()


func _on_SettingsIcon_body_entered(body):
	if body is Uto:
		Global.challengeData["utoEnteredSettings"] = true
		var ota: Ota = get_node_or_null("Ota")
		if ota and ota.follow_target:
			Global.challengeData["otaPosition"] = ota.global_position
		SceneManager.goto_scene("res://scenes/settings/SettingsScreen.tscn")


func _on_Texts_rules_changed(new_rule_key):
	uto.cancel_movement()
	call_deferred("on_rules_changed", new_rule_key)
