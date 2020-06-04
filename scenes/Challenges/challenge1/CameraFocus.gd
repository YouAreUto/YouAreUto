extends Node2D

var shaking := false

func _process(delta):
	pass
#	if shaking:
#		var shake_vector = Vector2(randi(), randi()).normalized()*($Timer.time_left/$Timer.wait_time)
#		offset = shake_vector
#	else:
#		offset = Vector2()
		

func _instantaneous_shake(amount):
	$Camera2D.offset = amount * 1.2 * Vector2(rand_range(-1, 1), rand_range(-1, 1))

func shake(duration):
	$Tween.interpolate_method(self, "_instantaneous_shake", 1, 0, duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

func _on_UTO_hit():
	shake(1)
