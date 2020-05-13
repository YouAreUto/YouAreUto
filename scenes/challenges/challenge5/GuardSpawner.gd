extends Node2D

export(PackedScene) var guardScene
export(float) var screenTime = 6 # seconds

signal newGuardSpawend


func _ready():
	# set position
	var vs = get_viewport_rect().size
	position.x = vs.x


func start():
	var spd =  Global.challengeData.get("guardSpeed")
	if spd == 0:
		return
	spawnGuard()
	yield(get_tree().create_timer(screenTime / 4), "timeout")
	spawnGuard()


func spawnGuard():
	if Global.Flashlight and !Global.isFlashlightOn():
		return
	var guard = createGuard()
	guard.position.x = guard.get_size().x / 2
	add_child(guard)
	var t :=  Tween.new()
	guard.add_child(t)
	t.interpolate_property(guard, "position:x",
		guard.position.x,
		-(get_viewport_rect().size.x + (guard.get_size().x / 2)),
		screenTime,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	t.connect("tween_completed", self, "_onGuardCrossedTheScreen", [guard])
	t.start()


func createGuard():
	var guard: Guard = guardScene.instance()
	guard.scale = 0.45 * Vector2(1,1)
	guard.get_node("Outline").hide()
	return guard


func _onGuardCrossedTheScreen(source_object, interpolated_property, guard):
	remove_child(guard)
	if Global.challengeData.get("guardSpeed") == 0.5:
		yield(get_tree().create_timer(2.5), "timeout")
	spawnGuard()


func _on_Challenge5_torch_activated():
	if get_child_count() > 0:
		return
	start()


func _on_Challenge5_torch_disabled():
	for c in get_children():
		c.queue_free()


func stopGuards():
	for c in get_children():
		for twn in c.get_children():
			if twn is Tween:
				twn.stop_all()
