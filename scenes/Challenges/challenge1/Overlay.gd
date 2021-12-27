extends CanvasLayer


func _on_UTO_killed():
	gameover()


func gameover():
	$AnimationPlayer.play("blink")


func victory():
	fadeIn()


func fadeIn(speed = 1):
	$AnimationPlayer.play("gloria", -1, speed)


func fadeOut(speed = 1):
	$AnimationPlayer.play("disappear", -1, speed)


func fadeToDark():
	$AnimationPlayer.play("fadeToDark")


func fadeFromDark():
	$AnimationPlayer.play("fadeFromDark")
