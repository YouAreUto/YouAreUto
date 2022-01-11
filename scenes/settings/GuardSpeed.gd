extends HBoxContainer

signal guardSpeedChanged

onready var guardSpeedLabel = $RangeControl/ColorRect/Label

var increment = 0.5


func disable(gray_out = false):
	if gray_out:
		modulate.a = 0.5
		$RangeControl/Left.disabled = true
		$RangeControl/Right.disabled = true
	else:
		increment = 0


func _on_Left_pressed():
	guardSpeedLabel.text = str(
		max(0.0, float(guardSpeedLabel.text) - increment)
	)
	emit_signal("guardSpeedChanged", float(guardSpeedLabel.text))


func _on_Right_pressed():
	guardSpeedLabel.text = str(
		min(1.5, float(guardSpeedLabel.text) + increment))
	emit_signal("guardSpeedChanged", float(guardSpeedLabel.text))


func getSpeed():
	return float(guardSpeedLabel.text)
