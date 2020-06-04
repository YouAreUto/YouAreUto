extends Node2D


# dependencies
onready var logo = $IntroNodes/Logo
onready var challenge = $IntroNodes/Challenge
onready var title = $IntroNodes/Title
onready var uto = $IntroNodes/UTO
onready var servant = $IntroNodes/Servant
onready var youAreUtoText = $IntroNodes/YouAreUto
onready var castle = $IntroNodes/Castle
onready var youMustEnter = $IntroNodes/YouMustEnterTheCastle
onready var otherRules = $IntroNodes/OtherRules


func _ready():
	setPositions()
	get_viewport().connect("size_changed", self, "onScreenResized")


func onScreenResized():
	setPositions()


func setPositions():
	var margins = {
		"generic": {
			"top": 40
		},
		"logo": {
			"left": 20,
			"top": 20
		},
		"servant": {
			"left": 60,
			"top": 40
		},

	}

	var newSize = get_viewport().get_visible_rect().size
	var vwCenterX = newSize.x * 0.5

	# logo
	logo.position.x = margins.logo.left
	logo.position.y = margins.logo.top

	# challenge title and text
	challenge.rect_position.x = vwCenterX - challenge.rect_size.x / 2
	challenge.rect_position.y = newSize.y * 0.05 - challenge.rect_size.y / 2
	title.rect_position.x = vwCenterX - title.rect_size.x / 2
	title.rect_position.y = (challenge.rect_position.y + challenge.rect_size.y)

	# first challenge rule text
	youAreUtoText.rect_position = Vector2(
		vwCenterX - youAreUtoText.rect_size.x / 2,
		title.rect_position.y + title.rect_size.y + 120
	)

	# servant and uto
	servant.position = Vector2(
		vwCenterX + margins.servant.left + (servant.getSize().x / 2),
		youAreUtoText.rect_position.y + youAreUtoText.rect_size.y + (servant.getSize().y / 2) + margins.servant.top
	)

	uto.position = Vector2(
		vwCenterX - (servant.getSize().x / 2) - margins.servant.left,
		servant.position.y
	)

	#
	youMustEnter.rect_position = Vector2(
		vwCenterX - youMustEnter.rect_size.x / 2,
		servant.position.y + servant.getSize().y / 2 + margins.generic.top
	)

	castle.position = Vector2(
		vwCenterX,
		youMustEnter.rect_position.y + youMustEnter.rect_size.y + castle.getSize().y / 2 + margins.generic.top
	)

	otherRules.rect_position = Vector2(
		vwCenterX - otherRules.rect_size.x / 2,
		castle.position.y + castle.getSize().y / 2 + margins.generic.top
	)


func _on_DragUtoHereToStart_uto_entered():
	$Overlay/AnimationPlayer.play("appear")
