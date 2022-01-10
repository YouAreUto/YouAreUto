extends CanvasLayer

signal rules_changed(new_rule_key)

var rule_bottom_y = 0
var spacing = 26

onready var youareuto_label = $Control/YouAreUto
onready var control = $Control


func _ready() -> void:
	rule_bottom_y = Global.vw.size.y - 1175
	youareuto_label.rect_position.y = rule_bottom_y
	_update_rule_bottom(youareuto_label)


func add_rule(rule_key):
	var rule_label: Label = find_node(rule_key.capitalize())
	if rule_label.visible:
		return
	rule_label.set_visible(true)
	if rule_key != "servant":
		_align_text_bottom(rule_label)
	emit_signal("rules_changed", rule_key)
	match rule_key:
		"ota":
			var guard1 = find_node("Guard")
			if not guard1.visible:
				guard1.set_visible(true)
				_align_text_bottom(guard1)
				# swap ota and guard1
				var tmp_y = rule_label.rect_position.y
				rule_label.rect_position.y = guard1.rect_position.y
				guard1.rect_position.y = tmp_y
		"servant":
			rule_label.rect_position.y = get_viewport().get_visible_rect().size.y - 200
		"guard":
			var guard2 = find_node("Guard2")
			var guard1 = find_node("Guard")
			guard1.text = guard1.text.trim_suffix(".") # remove the point from the string
			guard2.set_visible(true)
			_align_text_bottom(guard2)
		"poet":
			activate_collisions()
		_:
			pass


func _align_text_bottom(rule_label: Label):
	rule_label.rect_position.y = rule_bottom_y + spacing
	_update_rule_bottom(rule_label)


func _update_rule_bottom(l: Label):
	rule_bottom_y = l.rect_position.y + l.rect_size.y * l.rect_scale.y


func activate_collisions():
	for ct in get_node("Control").get_children():
		var t: Label = ct
		var collision_shape: CollisionShape2D = t.find_node("CollisionShape2D")
		var rect_shape = RectangleShape2D.new()
		if t.name == "Poet":
			if t.rect_size.x < Global.vw.size.x - 100:
				t.text = " - - - - " + t.text + " - - - - "
				yield(t, "resized")
				t.rect_position.x = Global.vw.size.x / 2 - t.rect_size.x / 2
		collision_shape.position = t.rect_size / 2
		collision_shape.disabled = !ct.visible
		yield(get_tree(), "idle_frame")
		rect_shape.extents = t.rect_size / 2
		rect_shape.extents.x = Global.vw.size.x / 2 - 25
		collision_shape.shape = rect_shape
