extends RayCast2D


onready var guard: Guard = get_parent()

var speed = -200
var half_width
var collide_with_blocks = true

var collisions = {
	per_second = 0,
	timer = 0,
}


func _ready():
	get_tree().connect("screen_resized", self, "on_screen_resize")
	on_screen_resize()
	half_width = guard.get_size().x / 2


func on_screen_resize():
	speed = sign(speed) * Global.vw.size.x / 2
	speed *= 0.9


func _physics_process(delta):
	collisions.timer += delta
	cast_to = Vector2(-50, 0)
	var edge = { right = Global.vw.size.x + half_width + 50 }
#	if collisions.timer > 1:
#		collisions.timer = 0
#		collisions.per_second = 0
#	if collisions.per_second > 30:
#		set_physics_process(false)
	var going_right = speed > 0
	var out_of_screen_right = guard.global_position.x + delta * speed >= edge.right
	if (going_right and out_of_screen_right):
		speed *= -1

	if collide_with_blocks:
		force_raycast_update()
		var col = get_collider()
		if col is Block:
			if (guard.global_position.x > col.global_position.x) and speed < 0:
		#		collisions.per_second += 1
				speed *= -1
			elif (guard.global_position.x <= col.global_position.x) and speed > 0:
				speed *= -1
	var movement = delta * speed
	guard.global_position.x = wrapf(guard.global_position.x + movement, -half_width, edge.right)
