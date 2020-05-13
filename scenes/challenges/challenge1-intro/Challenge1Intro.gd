extends Node2D


# dependencies
onready var challenge = $Node2D/Challenge
onready var title = $Node2D/Title
onready var logo = $Node2D/Logo
onready var herald = $Node2D/Herald
onready var heraldText = $Node2D/HeraldText
onready var uto = $Node2D/UTO
onready var utoText = $Node2D/UtoText
onready var king = $Node2D/King
onready var kingText = $Node2D/KingText


func _ready():
	Global.data["currentChallenge"] = 1
	get_viewport().connect("size_changed", self, "on_screen_resized")
	on_screen_resized()


func emitStartGameSignal():
	SceneManager.goto_scene("res://scenes/challenges/challenge1/Challenge1.tscn")


func positionObjects():
	var distanceBetweenRows = 200
	var verticalTextOffset = 26  # relative to the icon
	var margins = {
		"logo": {
			"left": 20,
			"top": 20
		}
	}
	var newSize = get_viewport().get_visible_rect().size
	var vwCenterX = newSize.x * 0.5

	# logo
	logo.position.x = margins.logo.left
	logo.position.y = margins.logo.top

	# challenge is a label ("Challenge 1")
	challenge.rect_position.x = vwCenterX - challenge.rect_size.x / 2
	challenge.rect_position.y = newSize.y * 0.05 - challenge.rect_size.y / 2
	title.rect_position.x = vwCenterX - title.rect_size.x / 2
	title.rect_position.y = (challenge.rect_position.y + challenge.rect_size.y)

	# uto
	var utoSize = uto.get_node("Sprite").texture.get_size()
	uto.position.x = vwCenterX
	uto.position.y = newSize.y * 0.25
	utoText.rect_position.x = vwCenterX - utoText.rect_size.x / 2
	utoText.rect_position.y = uto.position.y + utoSize.y / 2 + verticalTextOffset

	# herald
	herald.position.x = vwCenterX
	herald.position.y = newSize.y * 0.45
	heraldText.rect_position.x = vwCenterX - heraldText.rect_size.x / 2
	heraldText.rect_position.y = herald.position.y + utoSize.y / 2 + verticalTextOffset

	# king
	king.position.x = vwCenterX
	king.position.y = newSize.y * 0.63
	kingText.rect_position.x = vwCenterX - kingText.rect_size.x / 2
	kingText.rect_position.y = king.position.y + utoSize.y / 2 + verticalTextOffset


func appear():
	$Node2D/AnimationPlayer.play("appear")

# signal bindings

func on_screen_resized():
	positionObjects()


func _on_DragUtoHereToStart_uto_entered():
	$Node2D/UTO/Trail.emitting = false
	$Node2D/AnimationPlayer.play("disappear")
	$Node2D/UTO.set_process_input(false)
