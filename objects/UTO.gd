class_name Uto
extends KinematicBody2D

signal killed
signal hit

#signal kingKilled

onready var _bounds = $_bounds
onready var vwSize = get_viewport_rect().size
onready var utoSize := getUtoSize()

# NOTE: this should be removed. Kill/victory logic should not be handled by Uto. Look at UtoGameoverArea.gd
# set it to false when Uto is
# used in a menu and you don't want him to kill or be killed
export var enemiesInteractionEnabled := true 
export var showOutline := true

var speed = 20
var velocity := Vector2()
var target_position := Vector2()  # target position in global coordinates
var colliding = false
var holding = false  # true when drag start from  Uto,
# false otherwise
var heraldKilled = false
var alive = true # true if UTO is alive

const detectionRadiusForDrag = 100
const dragThresholdForMovement = 26


func _ready():
	$Trail.emitting = true
	$Outline.visible = showOutline


func _physics_process(delta):
	if not alive:
		return
	# if user is not giving input
	if not holding:
		# don't move UTO
		target_position = global_position
		return
	if (target_position - position).length() > dragThresholdForMovement:
		move_and_slide(speed * (target_position - position))
		clampPositionInsideTheScreen()


func _unhandled_input(event):
	if not alive:
		return
	if event is InputEventScreenDrag:
		handle_drag(event)
	if event is InputEventScreenTouch:
		handle_touch(event)


func handle_drag(event: InputEventScreenDrag):
	target_position = event.position


func handle_touch(event: InputEventScreenTouch):
	if event.pressed and event.position.distance_to(global_position) < detectionRadiusForDrag:
		holding = true
	if not event.pressed:
		holding = false


func getUtoSize() -> Vector2:
	return Vector2(
		_bounds.shape.extents.x * scale.x,
		_bounds.shape.extents.y * scale.y
	)


func clampPositionInsideTheScreen():
	# clamp Uto inside the viewport
	if position.x < utoSize.x:
		position.x = utoSize.x
	if position.x > vwSize.x - utoSize.x:
		position.x = vwSize.x - utoSize.x
	if position.y < utoSize.y:
		position.y = utoSize.y
	if position.y > vwSize.y - utoSize.y:
		position.y = vwSize.y - utoSize.y

# signal bindings


func _on_HitArea_area_entered(area: Area2D):
	# LEGACY method for classic challenged from 1 to 5. This should be removed
	# and refactored in the future.
	if !enemiesInteractionEnabled: return
	# UTO dies on enemy collision (this is a legacy check for challenge 1 to 5)
	if area.is_in_group("enemy") and !Global.challengeData.get("UtoIsAServant"):
		kill()
	# UTO kills on Herald collision
	if area.is_in_group("herald") and !heraldKilled:
		heraldKilled = true
		var herald = area.get_parent()
		herald.kill()
		emit_signal("hit")
#	if area.is_in_group("king") and heraldKilled:
#		emit_signal("kingKilled")


func kill():
	alive = false
	set_physics_process(false)
	emit_signal("killed")
