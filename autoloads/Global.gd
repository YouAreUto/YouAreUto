extends Node



const TEXTUES_PATHS = "res://assets/sprites/characters/"

""" Contains global data useful for all the game duration.
It should never be reset."""
var data = {
	"currentChallenge": 3,

}

var save_data = {"completed_challenges":[]}
var file_pass = "YouArePassword1234"
""" Contains data for the current challenge.
It should be reset every time the player goes to a new challenge. """
var challengeData = {
}

var challengesOrder := [
	{
		"intro": "res://scenes/Challenges/challenge1-intro/Challenge1Intro.tscn",
		"challenge": "res://scenes/Challenges/challenge1/Challenge1.tscn",
	},
	{
		"intro": "res://scenes/Challenges/challenge2-intro/Challenge2Intro.tscn",
		"challenge": "res://scenes/Challenges/challenge2/Challenge2.tscn",
	},
	{
		"intro": "res://scenes/Challenges/challenge3-intro/Challenge3Intro.tscn",
		"challenge": "res://scenes/Challenges/challenge3/Challenge3.tscn",
	},
	{
		"intro": "res://scenes/Challenges/challenge4-intro/Challenge4Intro.tscn",
		"challenge": "res://scenes/Challenges/challenge4-intro/Challenge4Intro.tscn", # this is the same, but it's correct
	},
	{
		"intro": "res://scenes/Challenges/challenge5-intro/Challenge5Intro.tscn",
		"challenge": "res://scenes/Challenges/challenge5/Challenge5.tscn",
	},
	{
		"intro": "res://scenes/Challenges/challenge6-intro/challenge6Intro.tscn",
		"challenge": "res://scenes/Challenges/challenge6/challenge6.tscn",
	},
	{
		"intro": "res://scenes/Challenges/challenge7-intro/Challenge7Intro.tscn",
		"challenge": "res://scenes/Challenges/challenge7/Challenge7.tscn",
	},
	{
		"intro": "res://scenes/CTA/CTA.tscn",
	},
]

var vw: Rect2 # viewport
var challenges_count = 0
var Flashlight


func _ready():
	load_game()
	if Engine.has_singleton("Flashlight"):
		Flashlight = Engine.get_singleton("Flashlight")
	vw = get_viewport().get_visible_rect()
	get_viewport().connect("size_changed", self, "on_size_changed")
	challenges_count = len(challengesOrder) - 1


func on_size_changed():
	vw = get_viewport().get_visible_rect()


func isFlashlightOn(mockFlashlight = false, mockedState = false):
	if mockFlashlight:
		return mockedState

	if Flashlight:
		return Flashlight.isFlashlightOn()
	else:
		return false

	
func getChallengePath(index: int) -> Dictionary:
	return challengesOrder[index - 1]


func goToNextChallenge(showIntro: bool):
	data.currentChallenge += 1
	load_challenge(data.currentChallenge, showIntro)


func load_challenge(challenge_number, show_intro = true):
	challengeData = {}
	var challenge_path = getChallengePath(challenge_number)
	SceneManager.goto_scene(challenge_path.intro if show_intro else challenge_path.challenge)

func isnull(obj):
	return obj == null

func save_game():

	
	var file = File.new()
	if file.open_encrypted_with_pass("user://gamesave.save", File.WRITE, file_pass) != 0:
		return
	
	if save_data != null:
		file.store_var(save_data)
	file.close()
	print("STORED")
	
func load_game():
	var file = File.new()
	if not file.file_exists("user://gamesave.save"):
		save_game()

	if file.open_encrypted_with_pass("user://gamesave.save", File.READ, file_pass) != 0:
		return

	var data = file.get_var()
	if data != null:
		save_data = data

