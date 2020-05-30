class_name Main
extends Node

onready var anim: AnimationPlayer = $Transition/AnimationPlayer
onready var current_scene := $CurrentScene


func _init():
	SceneManager.main_node = self


func _ready():
	SceneManager.on_main_node_ready()
	anim.play("hide_overlay")
