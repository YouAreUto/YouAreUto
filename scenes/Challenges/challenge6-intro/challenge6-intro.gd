extends Node2D


onready var uto = $UTO
onready var timer = $Delay

export(PackedScene) var next_scene


func _ready():
	get_viewport().connect("size_changed", self, "set_layout")
	set_layout()


func set_layout():
	var yau = get_node("BG/Control/YouAreUto")
	uto.position = Vector2(
		Global.vw.size.x / 2,
		yau.rect_position.y + yau.rect_size.y + uto.getUtoSize().y + 60
	)


func start_challenge():
	$Overlay.fadeIn()
	yield($Overlay/AnimationPlayer, "animation_finished")
	SceneManager.goto_scene(next_scene.resource_path)


func _on_Area2D_body_entered(body):
	if body is Uto:
		body.set_physics_process(false)
		timer.start()
		yield(timer, "timeout")
		start_challenge()
