extends VBoxContainer


func _ready():
	resize()
	get_tree().connect("screen_resized", self, "resize")


func resize():
	rect_min_size.y = Global.vw.size.y - 120
