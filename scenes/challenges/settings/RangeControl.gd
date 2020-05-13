extends HBoxContainer



func _on_Left_button_down():
	$"Left/left-btn-icon2".show()


func _on_Right_button_down():
	$Right/TextureRect2.show()


func _on_Left_button_up():
	$"Left/left-btn-icon2".hide()


func _on_Right_button_up():
	$Right/TextureRect2.hide()
