extends Node

onready var uto: Uto = get_parent()

export(Texture) var servant_texture


func becomeAServant():
	uto.get_node("Sprite").texture = load("res://assets/sprites/characters/char-servant.png")
	changeTrailColor()
	uto.enemiesInteractionEnabled = false


func changeTrailColor():
	var trail: Particles2D = uto.get_node("Trail")
	var gradientColors: Gradient = trail.process_material.color_ramp.gradient
	gradientColors.set_color(0, Color(0.33, 0.6, 0.33))
	gradientColors.set_color(1, Color(0.3, 0.4, 0.3))


func _on_Definitely_UtoBecameACastleServant():
	becomeAServant()
