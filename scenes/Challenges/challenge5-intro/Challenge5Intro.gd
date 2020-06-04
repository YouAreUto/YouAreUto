extends Control

onready var uto = $UTO


func _ready():
	setPositions()


func setPositions():
	uto.position.x = get_viewport_rect().size.x / 2
	uto.position.y = $BlackArea.rect_position.y + uto.getUtoSize().y + 75

	# center the text block between "BlackPath" and the black box at the bottom
	var spaceAvailable = $BlackArea.rect_position.y - $BlackPath.rect_position.y + $BlackPath.rect_size.y
	var blockHeight = $Label6.rect_position.y + $Label6.rect_size.y - $VBoxContainer.rect_position.y
	var offset = ($BlackPath.rect_position.y + $BlackPath.rect_size.y + spaceAvailable - blockHeight) / 2
	var delta = offset - $VBoxContainer.rect_position.y
	for controlEl in [$VBoxContainer, $Chest, $Label6]:
		controlEl.rect_position.y += delta


func _on_StartArea_uto_entered():
	$Overlay.fadeToDark()
	yield($Overlay/AnimationPlayer, "animation_finished")
	SceneManager.goto_scene("res://scenes/Challenges/challenge5/Challenge5.tscn")
