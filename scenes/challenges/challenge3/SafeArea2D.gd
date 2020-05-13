extends Area2D

func _ready() -> void:
	pass


func _on_SafeArea2D_body_entered(body: PhysicsBody2D) -> void:
	if body is Uto:
		$LiftSound.play()
