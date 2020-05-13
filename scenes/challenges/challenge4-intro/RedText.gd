extends Label

var utoIsUp = false
var utoIsDown = false

var arrivedAtDestination = false

func _ready() -> void:
	if Global.challengeData.get("monochrome"):
		disableLogic()

func _on_Challenge4Intro_red_text_pushable() -> void:
	disableLogic()
	rect_position.y = get_parent().get_node("BlueTextCanBePushed").rect_position.y


func disableLogic():
	$StaticBody2D.set_collision_layer_bit(0, false)
	$StaticBody2D.set_collision_mask_bit(0, false)
	$TopTrigger.monitoring = false
	$BottomTrigger.monitoring = false
