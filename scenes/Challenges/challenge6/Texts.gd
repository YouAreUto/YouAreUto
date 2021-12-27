extends CanvasLayer

signal uto_lost_and_text_is_a_barrier
signal rules_changed(new_rule_key)

var rule_top_y = 0
var spacing = 30

onready var youareuto_label = $Control/YouAreUto
onready var control = $Control


func _ready() -> void:
	var vw = get_viewport().get_visible_rect()
	youareuto_label.rect_position.y = Global.vw.size.y / 2 - 250
	rule_top_y = youareuto_label.rect_position.y + youareuto_label.rect_size.y * youareuto_label.rect_scale.y


func add_rule(rule_key):
	call_deferred("_add_rule", rule_key)


func _add_rule(rule_key):
	var rule_label: Label = find_node(rule_key.capitalize())
	if rule_label.visible:
		return
	rule_label.set_visible(true)
	rule_label.rect_position.y = rule_top_y + spacing
	if rule_key != "servant":
		rule_top_y = rule_label.rect_position.y + rule_label.rect_size.y * rule_label.rect_scale.y
	emit_signal("rules_changed", rule_key)
	match rule_key:
		"servant":
			# "uto's definitely lost" text
			rule_label.rect_position.y = get_viewport().get_visible_rect().size.y - 200
			return
		"poet":
			activate_collisions()
		_:
			pass


func activate_collisions():
	for ct in control.get_children():
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
		rect_shape.extents = t.rect_size / 2
		rect_shape.extents.x = Global.vw.size.x / 2 - 25
		collision_shape.shape = rect_shape
