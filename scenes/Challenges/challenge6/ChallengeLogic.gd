extends Node

onready var dialogue = get_node("../Dialogue")
onready var texts = get_node("../Texts")
onready var servant_rule = get_node("../Texts/Control/Servant")
onready var guard_rule = get_node("../Texts/Control/Guard")
onready var ota_rule = get_node("../Texts/Control/Ota")
onready var poet_rule = get_node("../Texts/Control/Poet")
onready var captain_rule = get_node("../Texts/Control/Captain")
onready var uto = get_node("../UTO")
onready var ota = get_node("../OtaPath/OtaPathFollow/Ota")
onready var overlay = get_node("../Overlay")
onready var anims := get_node("../AnimationPlayer")


func _ready():
	for g in get_tree().get_nodes_in_group("guards"):
		g.get_node("Outline").hide()
		g.get_node("Icon").texture = load("res://assets/sprites/characters/char-guard.png")


func _on_Servant_uto_entered(uto):
	if servant_rule.visible:
		return
	var appear_anim = start_dialogue("servant")
	yield(appear_anim, "completed")
	add_rule("servant")


func _on_Guard_uto_overlapped():
	if guard_rule.visible:
		return
	var appear_anim = start_dialogue("guard")
	yield(appear_anim, "completed")
	add_rule("guard")
	for g in get_tree().get_nodes_in_group("guards"):
		g.get_node("Outline").show()
		g.get_node("Icon").texture = load("res://assets/sprites/characters/char-guard-cut.png")
		g.disconnect("uto_overlapped", self, "_on_Guard_uto_overlapped")


# from guards
func _on_OtaDetector_ota_entered(detector):
	if !uto.alive:
		return
	var anims: AnimationPlayer = get_node("../AnimationPlayer")
	anims.stop()
	uto.kill()
	ota.set_process(false) # don't move
	# animate guard
	var guard = detector.get_parent()
	var t = Tween.new()
	guard.add_child(t)
	guard.z_index += 1
	t.interpolate_property(guard, "global_position", guard.global_position, ota.global_position, .8, Tween.TRANS_LINEAR)
	t.start()
	yield(get_tree().create_timer(.4), "timeout")
	overlay.gameover()
	yield(overlay.get_node("AnimationPlayer"), "animation_finished")
	SceneManager.goto_scene("res://scenes/gameover/GameOverScreen.tscn")


func _on_Ota_uto_entered() -> void:
	if ota_rule.visible:
		return
	var appear_anim = start_dialogue("ota")
	yield(appear_anim, "completed")
	add_rule("ota")
	add_rule("guard")
	anims.remove_ota_animation()
	call_deferred("ota_start_following_uto")


func _on_Poet_uto_entered() -> void:
	if poet_rule.visible:
		return
	var appear_anim = start_dialogue("poet")
	yield(appear_anim, "completed")
	add_rule("poet")


func _on_Captain_uto_entered() -> void:
	if captain_rule.visible:
		return
	if not "ota" in Global.challengeData.active_rules:
		var appear_anim = start_dialogue("captain")
		yield(appear_anim, "completed")
		add_rule("captain")


func start_dialogue(dialogue_key):
	get_tree().paused = true
	overlay.fadeIn(2)
	yield(overlay.get_node("AnimationPlayer"), "animation_finished")
	overlay.fadeOut(2)
	dialogue.show(dialogue_key)


func add_rule(rule_key):
	texts.add_rule(rule_key)


func ota_start_following_uto():
	var ota_path = ota.get_node("../..")
	var ota_path_follow = ota.get_node("..")
	ota_path_follow.remove_child(ota)
	get_parent().add_child(ota)
	ota_path.queue_free()
	ota.follow_uto(uto)


func _on_Dialogue_dialogue_ended(type):
	get_tree().paused = false
