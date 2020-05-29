extends CanvasLayer


var vwSize := Vector2() # viewport size, updated on resize


func _ready():
	vwSize = get_viewport().get_visible_rect().size
	positionObjects()
	get_viewport().connect("size_changed", self, "_on_size_changed")


func positionObjects():
	"""Positions all the game objects."""
	$BG.position.x = vwSize.x / 2


func _on_UTO_hit():
	$AnimationPlayer.play("hide_rule")


func _on_size_changed():
	# update member variable
	vwSize = get_viewport().get_visible_rect().size
	positionObjects()
