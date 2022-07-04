class_name Uto
extends KinematicBody2D

signal killed
signal hit

onready var vwSize = get_viewport_rect().size
onready var size: Vector2 = Vector2() setget ,getUtoSize

# NOTE: this should be removed. Kill/victory logic should not be handled by Uto. Look at UtoGameoverArea.gd
# set it to false when Uto is
# used in a menu and you don't want him to kill or be killed
export var enemiesInteractionEnabled := true
export var showOutline := true

var speed = 20
var target_position := Vector2()  # target position in global coordinates
var is_moving = false setget ,get_is_moving
var holding = false  # true when drag start from  Uto,
# false otherwise
var heraldKilled = false
var alive = true # true if UTO is alive

var delta_movement = Vector2()

const detectionRadiusForDrag = 100
const dragThresholdForMovement = 3


func _ready():
	$Trail.emitting = true
	$Outline.visible = showOutline


func _physics_process(_delta):
	if not alive:
		return
	delta_movement = Vector2()
	# if user is not giving input
	if not holding:
		# don't move UTO
		target_position = global_position
		return
	if (target_position - position).length() > dragThresholdForMovement:
		delta_movement = speed * (target_position - position)
		move_and_slide(delta_movement)
		clampPositionInsideTheScreen()


func get_is_moving():
	return delta_movement != Vector2()


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
	return $Sprite.texture.get_size() * $Sprite.scale * scale


func clampPositionInsideTheScreen():
	# half uto size
	var hs = self.size / 2
	vwSize = Global.vw.size
	# clamp Uto inside the viewport
	if global_position.x < hs.x:
		global_position.x = hs.x
	if global_position.x > vwSize.x - hs.x:
		global_position.x = vwSize.x - hs.x
	if global_position.y < hs.y:
		global_position.y = hs.y
	if global_position.y > vwSize.y - hs.y:
		global_position.y = vwSize.y - hs.y

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
	
	


func cancel_movement():
	target_position = global_position
