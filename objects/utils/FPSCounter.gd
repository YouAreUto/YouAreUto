extends Label

func _process(delta):
	text = str(Performance.get_monitor(Performance.TIME_FPS)) + " FPS"