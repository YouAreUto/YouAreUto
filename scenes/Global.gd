extends Node

""" Contains global data useful for all the game duration.
It should never be reset."""
var data = {
	"currentChallenge": 1,
	"solved": { # NOTE: this data is not used for persistency yet
		"challenge1": false,
		"challenge2": false,
		"challenge3": false
	}
}

""" Contains data for the current challenge.
It should be reset every time the player goes to a new challenge. """
var challengeData = {
}

const TEXTUES_PATHS = "res://assets/sprites/characters/"

var Flashlight


func _ready():
	if Engine.has_singleton("Flashlight"):
		Flashlight = Engine.get_singleton("Flashlight")


func isFlashlightOn(mockFlashlight = false, mockedState = false):
	if mockFlashlight:
		return mockedState

	if Flashlight:
		return Flashlight.isFlashlightOn()
	else:
		return false


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print(data)
		print(challengeData)


func get_global_data() -> Dictionary:
	return data


func getChallengePath(index: int) -> Dictionary:
	var challengesOrder := [
		{
			"intro": "res://scenes/challenges/challenge1-intro/Challenge1Intro.tscn",
			"challenge": "res://scenes/challenges/challenge1/Challenge1.tscn",
		},
		{
			"intro": "res://scenes/challenges/challenge2-intro/Challenge2Intro.tscn",
			"challenge": "res://scenes/challenges/challenge2/Challenge2.tscn",
		},
		{
			"intro": "res://scenes/challenges/challenge3-intro/Challenge3Intro.tscn",
			"challenge": "res://scenes/challenges/challenge3/Challenge3.tscn",
		},
		{
			"intro": "res://scenes/challenges/challenge4-intro/Challenge4Intro.tscn",
			"challenge": "res://scenes/challenges/challenge4-intro/Challenge4Intro.tscn", # this is the same, but it's correct
		},
		{
			"intro": "res://scenes/challenges/challenge5-intro/Challenge5Intro.tscn",
			"challenge": "res://scenes/challenges/challenge5/Challenge5.tscn",
		},
		{
			"intro": "res://scenes/cta2/CTA2.tscn",
		},
	]
	return challengesOrder[index - 1]


func goToNextChallenge(showIntro: bool):
	data.currentChallenge += 1
	var nextScene
	if showIntro:
		nextScene = getChallengePath(data.currentChallenge).intro
	else:
		nextScene = getChallengePath(data.currentChallenge).challenge
#	print(nextScene)
	challengeData = {}
	SceneManager.goto_scene(nextScene)
