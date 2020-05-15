extends KinematicBody2D
class_name Uto

signal killed
signal hit
signal kingKilled

# customizable parameters

# var mouse_drag_treshold = 22
onready var detectionRadiusForDrag = 100
onready var dragThresholdForMovement = 26
onready var utoSize := getUtoSize()
onready var vwSize = get_viewport_rect().size

export var enemiesInteractionEnabled := true # set to false when Uto is used in a menu and you don't want him to kill or be killed
export var showOutline := true

# state variables
var speed = 20
var velocity := Vector2()
var target_position := Vector2()  # target position in global coordinates
var followMouse = false
var colliding = false
var hovering = false  # true when mouse is on Uto, false otherwise (for mouse input)
var holding = false  # true when drag start from  Uto, false otherwise (for touch input)
var heraldKilled = false
var alive = true # true if UTO is alive
var activateDrag = false

func _ready():
	$Trail.emitting = true
	$Outline.visible = showOutline


func _physics_process(delta):
	# if user is not giving input
	if not holding:
		# don't move UTO
		target_position = global_position
		activateDrag = false
		return

	# if uto is dead
	if !alive:
		# don't move it
		return

	# position = target_position
	if (target_position - position).length() > dragThresholdForMovement:
		activateDrag = true

	if activateDrag:
		move_and_slide(speed * (target_position - position))
		clampPositionInsideTheScreen()


func _input(event):
	if not alive:
		return

	if event is InputEventScreenDrag or event is InputEventScreenTouch:
		handle_touch_input(event)
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		return
		handle_mouse_input(event)


func handle_mouse_input(event):
	var previousPos = global_position

	if event is InputEventMouseMotion:
		if followMouse:
			velocity = get_local_mouse_position().normalized() * speed

	if hovering:
		if event.is_action_pressed("ui_select"):
			followMouse = true

	if event.is_action_released("ui_select"):
		followMouse = false
		velocity = Vector2()


func handle_touch_input(event):
	if event is InputEventScreenDrag:
		# uto movement
		target_position = event.position

	if event is InputEventScreenTouch:
		if event.pressed and event.position.distance_to(global_position) < detectionRadiusForDrag:
			holding = true

		if !event.pressed	:
			holding = false


func getUtoSize() -> Vector2:
	return Vector2(
		$_bounds.shape.extents.x * scale.x,
		$_bounds.shape.extents.y * scale.y
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
	if !enemiesInteractionEnabled: return
	# UTO dies on enemy collision
	if area.is_in_group("enemy") and !Global.challengeData.get("UtoIsAServant"):
		killUto()
	# UTO kills on Herald collision
	if area.is_in_group("herald") and !heraldKilled:
		heraldKilled = true
		var herald = area.get_parent()
		herald.kill()
		emit_signal("hit")
	# UTO kills on King collision
	if area.is_in_group("king") and heraldKilled:
		emit_signal("kingKilled")


func killUto():
	alive = false
	emit_signal("killed")


func _on_InputArea_mouse_entered():
	hovering = true

func _on_InputArea_mouse_exited():
	hovering = false
