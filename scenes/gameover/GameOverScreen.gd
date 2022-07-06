extends Node2D

onready var text := $CanvasLayer/Text
var use_legacy_code = true


func _ready():
	setPositions()
	Global.challengeData = {}
	Global.connect("set_buttons_disabled", self, "disable_all_buttons")
	
func init(conf: Dictionary):
	if conf.has("text"):
		text.text = conf.text
	if conf.has("hideQuitButton"):
		$CanvasLayer/VBoxContainer/QuitButton.hide()
	if conf.has("use_legacy_code"):
		use_legacy_code = conf.get("use_legacy_code")


func setPositions():
	text.rect_position.x = get_viewport_rect().size.x * 0.5 - text.rect_size.x / 2


func _on_QuitButton_pressed():
	Global.emit_signal("set_buttons_disabled", true)
	SceneManager.goto_scene("res://scenes/MainMenu/MainMenu.tscn")
	

func _on_RestartButton_pressed():
	Global.emit_signal("set_buttons_disabled", true)
	if use_legacy_code:
		SceneManager.goto_scene(Global.getChallengePath(Global.data.currentChallenge).intro)
	else:
		SceneManager.restart_challenge()
	
	
func disable_all_buttons(is_disabled):
	$CanvasLayer/VBoxContainer/RestartButton.disabled = is_disabled
	$CanvasLayer/VBoxContainer/QuitButton.disabled = is_disabled
	$CanvasLayer/VBoxContainer/GetHintButton.disabled = is_disabled
	$CanvasLayer/VBoxContainer/GetFullSolutionButton.disabled = is_disabled
