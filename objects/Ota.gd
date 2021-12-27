extends Area2D
class_name Ota

signal uto_entered

onready var sprite = $Sprite

var state = "follow_path"
var follow_target: Node2D
var speed = 220


func _ready():
	set_size(130, 130)
	set_process(false)


func set_size(w, h):
	scale.x = w / sprite.texture.get_size().x
	scale.y = h / sprite.texture.get_size().y


func _on_Ota_body_entered(body: Node) -> void:
	if body is Uto:
		emit_signal("uto_entered")


func follow_uto(uto):
	follow_target = uto
	set_process(true)
	state = "follow_target"


func _process(delta):
	if follow_target and state == "follow_target":
		var target_distance = global_position.distance_to(follow_target.global_position)
		if target_distance > 130:
			var multiplier = target_distance / 80
			multiplier = 1 if target_distance < 150 else multiplier
			follow(delta * multiplier)


func follow(delta):
	position = lerp(position, follow_target.global_position, delta)
