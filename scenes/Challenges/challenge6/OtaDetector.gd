extends Area2D

signal ota_entered

onready var guard := get_node("../")


func _ready():
	$CollisionShape2D.disabled = true


func enable_collisions():
	$CollisionShape2D.disabled = false


func _on_OtaDetector_area_entered(area):
	if area is Ota:
		emit_signal("ota_entered", self)
#		attack_ota(area)


func shrink():
	$CollisionShape2D.shape.radius = 190
