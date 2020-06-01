extends Node2D

onready var waterDropScene = preload("res://objects/WaterDrop/WaterDrop.tscn")

var drop_every = 0.07 # sec
var sec_since_last_drop = 0


func _ready() -> void:
	randomize()


func instanceWaterDrop():
	var waterDrop = waterDropScene.instance()
	waterDrop.visible = false
	var scl = 0.35 + rand_range(-0.05, 0.05)
	waterDrop.scale = Vector2(scl, scl)
	waterDrop.connect("dropFinished", self, "remove_drop", [waterDrop])
	return waterDrop


func remove_drop(obj):
	obj.queue_free()


func _process(delta: float) -> void:
	sec_since_last_drop += delta
	if sec_since_last_drop > drop_every:
		sec_since_last_drop = 0
		var drop = instanceWaterDrop()
		add_child(drop)
		drop.position = Vector2(
			rand_range(0, get_viewport().get_visible_rect().size.x),
			rand_range(0, get_viewport().get_visible_rect().size.y)
		)
		drop.animate()
