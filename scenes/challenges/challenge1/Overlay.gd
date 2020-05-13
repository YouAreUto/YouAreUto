extends CanvasLayer


func _on_UTO_killed():
	$AnimationPlayer.play("blink")


func fadeIn():
	$AnimationPlayer.play("gloria")


func fadeToDark():
	$AnimationPlayer.play("fadeToDark")
	
	
func fadeFromDark():
	$AnimationPlayer.play("fadeFromDark")
