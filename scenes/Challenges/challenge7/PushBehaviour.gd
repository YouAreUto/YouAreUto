extends Node
class_name PushBehaviour

export var active := true

onready var block: Block =  get_parent()
onready var ray1: RayCast2D = $Ray1
onready var ray2 := $Ray2
onready var ray3 := $Ray3
onready var rays = [ray1, ray2, ray3]
onready var GRID_STEP = block.size / 2

onready var debug_node = get_parent().get_node("Debug")

var uto: Uto
var uto_ray: RayCast2D
var speed = 10


func _ready():
	set_physics_process(false)
	for ray in rays:
		ray.add_exception(self.block)


func _physics_process(delta):
	if active == false:
		return
	if !uto_ray or !uto:
		return
	if not uto.is_moving:
		return
	if not uto.holding:
		return #print("not holding")

	var dir := uto.target_position - uto.global_position
	var effort = dir.length()
	if effort < 60:
		return

	# set dir only if above treshold
	dir.x = dir.x if abs(dir.x) > 0.5 else 0.0
	dir.y = dir.y if abs(dir.y) > 0.5 else 0.0
	# move only in one direction at a time
	if abs(dir.x) > abs(dir.y):
		dir.y = 0
	elif abs(dir.y) > abs(dir.x):
		dir.x = 0

	dir = dir.normalized()
	uto_ray.cast_to = dir * 120
	uto_ray.force_raycast_update()
	debug_node.ray(uto_ray)
	var collider = uto_ray.get_collider()
	if collider != block:
		return

	var uto_above_block = uto.global_position.y < block.global_position.y
	var uto_below_block = uto.global_position.y > block.global_position.y
	var uto_left_from_block = uto.global_position.x < block.global_position.x
	var uto_rigth_from_block = uto.global_position.x > block.global_position.x
	var movement = Vector2()
	# vertical movement: process only if uto and block are aligned
	if abs(uto.global_position.x - block.global_position.x) < 30:
		if dir.y < 0 and uto_below_block:
			movement.y = -1
		elif dir.y > 0 and uto_above_block:
			movement.y = 1
	# horizontal movement: process only if uto and block are aligned
	elif abs(uto.global_position.y - block.global_position.y) < 30:
		if dir.x < 0 and uto_rigth_from_block:
			movement.x = -1
		elif dir.x > 0 and uto_left_from_block:
			movement.x = 1

	if movement != Vector2.ZERO:
		apply_movement(movement * GRID_STEP) # apply movement to self parent block
	else:
		for ray in rays:
			ray.cast_to = Vector2()


func apply_movement(movement: Vector2):
	if block_outside_view(block.global_position + movement, block.size - 1):
		return Vector2()

	# check if there are other blocks to push
	var s = (block.size) / 2
	var angle =  deg2rad(37)
	ray1.cast_to = movement.normalized() * s
	ray2.cast_to = ray1.cast_to.rotated(angle).normalized() * (s + 20)
	ray3.cast_to = ray1.cast_to.rotated(-angle).normalized() * (s + 20)
	var last_processed_block
	for ray in rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			var cascaded_block = ray.get_collider()
			# if already processed this block
			if cascaded_block == last_processed_block:
				continue
			var amount_moved = on_ray_collider_found(cascaded_block, movement)
			last_processed_block = cascaded_block
			if amount_moved == Vector2(): # cannot move
				return Vector2()
	push_block_step(block, movement)
	return movement


func on_ray_collider_found(cascaded_block, movement):
	if cascaded_block is Block and cascaded_block != self.block:
		# cascade push block to colliding blocks
		var bbb = cascaded_block.name
		var push_behaviour = cascaded_block.get_node("PushBehaviour")
		push_behaviour.uto = uto
		return push_behaviour.apply_movement(movement)
#		return block_movement
	return Vector2()


func push_block_step(collider: Block, movement: Vector2):
	var tween: Tween = collider.get_node_or_null("Tween")
	if !tween:
		tween = Tween.new()
		tween.name = "Tween"
		collider.add_child(tween)
	if tween.is_active():
		return # print("block", collider.name, " moving ", collider.position)
	var duration = .125
	tween.interpolate_property(collider,
		"position",
		collider.position,
		collider.position + movement,
		duration)
	tween.interpolate_property(uto,
		"global_position",
		uto.global_position,
		uto.global_position + movement,
		duration)
	set_physics_process(false)
	uto.set_physics_process(false)
	tween.start()
	yield(tween, "tween_all_completed")
	uto.set_physics_process(true)
	# activate physics process only for blocks pushed by uto. Avoids cascading blocks to be processed.
	if uto.global_position.distance_to(collider.global_position) < 150:
		set_physics_process(true)


func block_outside_view(g_pos: Vector2, b_size: float):
	if g_pos.y >= Global.vw.size.y - b_size / 2:
		return true
	# if trying to push it outside the screen from the top
	if g_pos.y < b_size / 2:
		return true
	if g_pos.x < b_size / 2:
		return true
	if g_pos.x > Global.vw.size.x - b_size / 2:
		return true
	return false


func _on_Area2D_body_entered(body):
	if body is Uto:
		uto = body
		if not body.get_node_or_null("uto_ray"):
			uto_ray = RayCast2D.new()
			uto_ray.name = "uto_ray"
			uto.add_child(uto_ray)
		else:
			uto_ray = uto.get_node("uto_ray")
		set_physics_process(true)


func _on_Area2D_body_exited(body):
	set_physics_process(false)
	debug_node.ray(null)
