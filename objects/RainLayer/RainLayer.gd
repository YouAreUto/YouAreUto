extends Node2D


export(String) var waterDropScenePath = "res://objects/WaterDrop/WaterDrop.tscn"
onready var waterDropScene = load(waterDropScenePath)

var drop_every = 0.07 # sec
var sec_since_last_drop = 0


func _ready() -> void:
	randomize()
	var poolSize = 40
	for i in range(poolSize):
		var waterDrop = instanceWaterDrop()
		$DropsPool.add_child(waterDrop)


func instanceWaterDrop():
	var waterDrop = waterDropScene.instance()
	waterDrop.visible = false
	var scl = 0.35 + rand_range(-0.05, 0.05)
	waterDrop.scale = Vector2(scl, scl)
	waterDrop.connect("dropFinished", self, "moveInPool", [waterDrop])
	return waterDrop


func moveInPool(obj):
	obj.visible = false
	remove_child(obj)
	$DropsPool.add_child(obj)


func getFromPool():
	if $DropsPool.get_child_count() > 0:
		var drop = $DropsPool.get_child(0)
		$DropsPool.remove_child(drop)
		return drop
	else:
		var waterDrop = instanceWaterDrop()
		print("Pool empty, created new drop")
		return waterDrop


func _process(delta: float) -> void:
	sec_since_last_drop += delta
	if sec_since_last_drop > drop_every:
		sec_since_last_drop = 0
		var drop = getFromPool()
		add_child(drop)
		drop.position = Vector2(
			rand_range(0, get_viewport().get_visible_rect().size.x),
			rand_range(0, get_viewport().get_visible_rect().size.y)
		)
		drop.animate()



