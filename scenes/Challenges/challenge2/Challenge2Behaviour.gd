extends Node

onready var uto: Uto = get_parent()
export(Texture) var servant_texture
var collisions = []


func _ready():
	disable_collisions()


func becomeAServant():
	uto.get_node("Sprite").texture = load("res://assets/sprites/characters/char-servant.png")
	changeTrailColor()
#	uto.enemiesInteractionEnabled = false


func disable_collisions():
	collisions = [uto.collision_layer, uto.collision_mask]
	uto.collision_layer = 0
	uto.collision_mask = 0


func activate_collisions():
	uto.collision_layer = collisions[0]
	uto.collision_mask = collisions[1]

func changeTrailColor():
	var trail: Particles2D = uto.get_node("Trail")
	var gradientColors: Gradient = trail.process_material.color_ramp.gradient
	gradientColors.set_color(0, Color(0.33, 0.6, 0.33))
	gradientColors.set_color(1, Color(0.3, 0.4, 0.3))


func _on_Definitely_UtoBecameACastleServant():
	becomeAServant()


func _on_Timer_timeout():
	activate_collisions()
