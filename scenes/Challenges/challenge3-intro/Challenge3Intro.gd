extends Node2D

onready var uto: Uto = $BG/UTO
onready var ruleText = $BG/RuleText
onready var ruleText2 = $BG/RuleText2
onready var overlayAnims: AnimationPlayer = $Overlay/AnimationPlayer
onready var poet = $BG/Poet

func _ready() -> void:
	setLayout()
	get_viewport().connect("size_changed", self, "setLayout")


func setLayout():
	uto.position = Vector2(
		ruleText.rect_position.x + ruleText.rect_size.x / 2,
		ruleText.rect_position.y + ruleText.rect_size.y + uto.getUtoSize().y + 16
	)
	poet.position = Vector2(
		uto.position.x,
		ruleText2.rect_position.y + ruleText2.rect_size.y + (poet.texture.get_size().y * poet.scale.y) - 20
	)



func _on_AnimationPlayer_animation_finished(anim_name):
	# if overlay appeared
	if anim_name == "appear":
		SceneManager.goto_scene("res://scenes/Challenges/challenge3/Challenge3.tscn")


func _on_StartArea_uto_entered() -> void:
	overlayAnims.play("appear")
