extends Node2D
tool

signal uto_entered

onready var redLine = $RedLine
onready var label = $Label
onready var triggerArea = $Label/Area2D


func _ready():
	setLayout()
	if not Engine.editor_hint:
		get_viewport().connect("size_changed", self, "onScreenResized")


func onScreenResized():
	setLayout()


func setLayout():
	var newSize = get_viewport().get_visible_rect().size

	# "Drag uto here to start" section
	label.rect_position.x = newSize.x / 2 - label.rect_size.x / 2
	label.rect_position.y = newSize.y * 0.88

	redLine.position.x = 0
	redLine.position.y = newSize.y * 0.8
	redLine.scale.x = newSize.x / redLine.texture.get_width()

	triggerArea.position.x = label.rect_size.x / 2
	triggerArea.position.y = label.rect_size.y / 2

	triggerArea.get_node("CollisionShape2D").shape.extents.x = newSize.x / 2


func _on_Area2D_body_entered(body):
	if body is Uto:
		body.set_physics_process(false)
		$Label/Area2D/Delay.start()
		yield($Label/Area2D/Delay, "timeout")
		emit_signal("uto_entered")
