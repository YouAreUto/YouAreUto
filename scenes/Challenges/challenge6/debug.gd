extends Node
tool

export var god_mode = false setget set_god_mode
export(PoolStringArray) var forced_rules


func set_god_mode(val):
	god_mode = val
	if Engine.editor_hint:
		var uto: Uto = get_node("../UTO")
		var ota: Ota = get_node("../OtaPath/OtaPathFollow/Ota")
		uto.get_node("HitArea").monitorable = !val
		ota.monitorable = !val


func _ready():
	if !OS.is_debug_build():
		queue_free()
	else:
		call_deferred("force_rule")


func force_rule():
	if forced_rules.size() > 0:
		for rule in forced_rules:
			get_node("../Texts").add_rule(rule)
