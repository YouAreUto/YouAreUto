extends Node2D


func _ready():
	$UTO/Trail.emitting = false
	$UTO.set_process_input(false)


func activateUto():
		$UTO/Trail.emitting = true
		$UTO.set_process_input(true)

