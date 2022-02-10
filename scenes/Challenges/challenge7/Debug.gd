extends Node2D


var ray: RayCast2D


func ray(r: RayCast2D):
	ray = r


func _process(delta):
#	update_point_visibility()
	pass


func update_point_visibility():
	if get_node("../PushBehaviour").is_physics_processing():
		$Point.visible = true
	else:
		$Point.visible = false


func _draw():
	if ray != null:
		draw_line(ray.position, ray.cast_to, Color.red, 4, true)
