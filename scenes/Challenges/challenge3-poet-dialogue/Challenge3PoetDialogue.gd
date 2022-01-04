extends Node2D

onready var uto = $WhiteCircle/UTO
onready var whiteCircle = $WhiteCircle
onready var balloonUto = $WhiteCircle/BalloonUto
onready var balloonPoet = $WhiteCircle/BalloonPoet
onready var toBeContinued = $ToBeContinued


func _ready() -> void:
	uto.set_process_input(false)
	set_process_input(false)
	setLayout()
	$AnimationPlayer.play("Start")


func setLayout():
	var vw = get_viewport_rect().size
	whiteCircle.position = Vector2(
		vw.x / 2,
		vw.y * 0.65
	)
	toBeContinued.rect_position = Vector2(
		vw.x / 2 - toBeContinued.rect_size.x / 2 + 6,
		vw.y * 0.9 - toBeContinued.rect_size.y / 2
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select") or event is InputEventScreenTouch:
		SceneManager.goto_scene("res://scenes/victory/VictoryScreen.tscn", { "use_legacy_code": true })


func onDialogueDisplayed():
	set_process_input(true)
