extends HBoxContainer
tool

export(Texture) var selectionTexture

# parameters
export var challengeName: String
var challengeNumber: int
export var textureScale = 1.3
export var disabled = false

# dependencies
onready var label = $Label
onready var numberLabel = $TextureRect/ChallengeNumber
onready var textureRect = $TextureRect
onready var selectedSprite = $TextureRect/SelectedSprite
onready var challengeSelectionList = get_parent()

signal challengeItemPressed


func _ready() -> void:
	setSelected(false)
	label.text = challengeName
	var split = name.split("ChallengeItem")
	challengeNumber = int(split[1])
	if challengeNumber == 5 and OS.get_name() == "iOS":
		disabled = true
	# scale the texture rect up
	textureRect.expand = true
	textureRect.rect_min_size = textureScale * textureRect.texture.get_size()

	selectedSprite.texture = selectionTexture
	numberLabel.text = str(challengeNumber)

	if disabled:
		modulate.a = 0.5


func _on_HBoxContainer_gui_input(event: InputEvent) -> void:
	if disabled:
		return

	if event is InputEventMouseButton and event.is_action_released("ui_select"):
		emit_signal("challengeItemPressed", challengeNumber)


func setSelected(selected):
	if selected:
		textureRect.self_modulate.a = 0
		selectedSprite.modulate.a = 1
	else:
		textureRect.self_modulate.a = 1
		selectedSprite.modulate.a = 0


func isSelected():
	return selectedSprite.modulate.a == 1
