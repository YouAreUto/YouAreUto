extends CanvasLayer


onready var shader = $GrayScaleShader


func _ready():
	check()


func check():
	shader.visible = Global.challengeData.get("monochrome", false)
