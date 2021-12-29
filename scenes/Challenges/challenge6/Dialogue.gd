extends CanvasLayer

signal dialogue_ended

var dialogue_type = ""
var was_pressed = false

onready var baloon: TextureRect = $WhiteCircle/DialogueBaloon
onready var npc: Sprite = $WhiteCircle/NPC
onready var overlay = get_node("../Overlay")

var dialogue_baloons = {}


func _ready():
	layer = -2
	for el in ["captain", "guard", "ota", "poet", "servant"]:
		dialogue_baloons[el] = load("res://scenes/Challenges/challenge6/assets/balloon-ch6-%s.png" % [el])



func hide():
	var anims = overlay.get_node("AnimationPlayer")
	overlay.fadeIn(2)
	yield(anims, "animation_finished")
	layer = -2
	overlay.fadeOut(2)


func show(dialogue = ""):
	dialogue_type = dialogue
	baloon.texture = dialogue_baloons[dialogue]
	npc.texture = load("res://assets/sprites/characters/char-%s.png" % [dialogue])
	layer = 1


func on_release():
	if layer == 1:
		hide()
		emit_signal("dialogue_ended", dialogue_type)


func _input(event: InputEvent) -> void:
	if layer != 1:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			was_pressed = true
		else:
			if was_pressed:
				on_release()
				was_pressed = false
