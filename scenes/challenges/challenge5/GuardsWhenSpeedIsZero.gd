extends Node2D


onready var challenge5 = get_node('../../../Challenge5')


func _ready():
	$Guard/UtoGameoverArea.monitoring = false
	$Guard2/UtoGameoverArea.monitoring = false


func showAndActivate():
	show()
	$Guard/UtoGameoverArea.monitoring = true
	$Guard2/UtoGameoverArea.monitoring = true


func _on_Challenge5_torch_disabled():
	hide()
	$Guard/UtoGameoverArea.monitoring = false
	$Guard2/UtoGameoverArea.monitoring = false


func _on_Challenge5_torch_activated():
	if Global.isFlashlightOn(challenge5.debug.enabled, challenge5.get_node("flash").pressed):
		if Global.challengeData.get("guardSpeed") == 0:
			showAndActivate()
