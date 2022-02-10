extends Control

onready var uto: Uto = $UTO
onready var gate = $Gate
onready var overlayAnims: AnimationPlayer = $Overlay/AnimationPlayer


func _ready() -> void:
	setLayout()
	get_viewport().connect("size_changed", self, "setLayout")


func setLayout():
	var w = Global.vw.size.x
	uto.position = Vector2(
		w / 2 + w / 2 - gate.rect_global_position.x - 35,
		gate.rect_position.y + 50
	)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "appear":
		SceneManager.goto_scene("res://scenes/Challenges/challenge7/Challenge7.tscn")


func _on_StartArea_uto_entered() -> void:
	overlayAnims.play("appear")
