extends CanvasLayer

signal dialogue_ended

var dialogue_type = ""
var was_pressed = false

onready var baloon: TextureRect = $WhiteCircle/DialogueBaloon
onready var npc: Sprite = $WhiteCircle/NPC
onready var overlay = get_node("../Overlay")


func _ready():
	layer = -2


func hide():
	var anims = overlay.get_node("AnimationPlayer")
	overlay.fadeIn(2)
	yield(anims, "animation_finished")
	layer = -2
	overlay.fadeOut(2)


func show(dialogue = ""):
	dialogue_type = dialogue
	baloon.texture = load("res://scenes/Challenges/challenge6/assets/balloon-ch6-%s.png" % [dialogue])
	npc.texture = load("res://assets/sprites/characters/char-%s.png" % [dialogue])
	layer = 1


func on_release():
	if layer == 1:
		emit_signal("dialogue_ended", dialogue_type)
		hide()


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
