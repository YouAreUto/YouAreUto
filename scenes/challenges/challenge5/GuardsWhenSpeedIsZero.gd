extends Node2D


onready var challenge5 = get_node('/root/Challenge5')


func _ready():
	$Guard/Area2D/CollisionShape2D.disabled = true
	$Guard2/Area2D/CollisionShape2D.disabled = true


func showAndActivate():
	show()
	$Guard/Area2D/CollisionShape2D.disabled = false
	$Guard2/Area2D/CollisionShape2D.disabled = false


func _on_Challenge5_torch_disabled():
	hide()
	$Guard/Area2D/CollisionShape2D.disabled = true
	$Guard2/Area2D/CollisionShape2D.disabled = true


func _on_Challenge5_torch_activated():
	if Global.isFlashlightOn(challenge5.debug.enabled, challenge5.get_node("flash").pressed):
		if Global.challengeData.get("guardSpeed") == 0:
			showAndActivate()
