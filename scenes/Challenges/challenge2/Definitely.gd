extends StaticBody2D

# signals

signal UtoBecameACastleServant

# dependencies

export (NodePath) var utoPath
onready var uto: Uto = get_node(utoPath)

# configurable variables

export (float) var movingSpeed = 1

# state variable

var startingX: int
var utoIsBelow := false
var stopMoving = false


func _ready():
	startingX = position.x


func _process(delta):
	if stopMoving:
		set_process(false)
		if !Global.challengeData.UtoIsAServant:
			emit_signal("UtoBecameACastleServant")
		return
	var utoGoingUp = uto.target_position.y - uto.position.y < 0
	if utoIsBelow and utoGoingUp:
		position.y -= movingSpeed


func _on_UtoDetector_body_entered(body):
	if body is Uto:
		utoIsBelow = true


func _on_UtoDetector_body_exited(body):
	if body is Uto:
		utoIsBelow = false


func _on_YouDetector_body_entered(body):
	if body.name == "YouText":
		stopMoving = true

