extends CenterContainer

export(NodePath) var padre
var challenge1

# Called when the node enters the scene tree for the first time.
func _ready():
	challenge1 = get_node(padre)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var followMouse = false

func _process(delta):
	if followMouse:
		rect_position = challenge1.get_local_mouse_position() - Vector2(rect_size.x * rect_scale.x * 0.5, rect_size.y * rect_scale.y * 0.5)
	
func _on_SamuraiIcon_gui_input(event: InputEvent):
	if event.is_action_pressed("ui_select"):
		followMouse = true
		
	if event.is_action_released("ui_select"):
		followMouse = false
