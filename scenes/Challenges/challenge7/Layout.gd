extends Node

onready var challenge: Challenge = get_parent()
onready var uto: Uto = get_node("../UTO")
onready var gate: Gate = challenge.get_node("Gate")
onready var settings_icon = challenge.get_node("SettingsIcon")
onready var guard1 = challenge.get_node("CenterBlocks/GuardPawn")
onready var guard2 = challenge.get_node("CenterBlocks/GuardPawn2")
onready var ch7bg: TextureRect = challenge.get_node("BG/Ch7Bg")
onready var black_texture = challenge.get_node("BG/TextureRect")

# blocks nodes
onready var uto_is_you = challenge.get_node("UtoIsYou")
onready var black_is_poison = challenge.get_node("BlackIsPoison")
onready var center_blocks = challenge.get_node("CenterBlocks")
onready var text_is_push = challenge.get_node("TextIsPush")
onready var guard_is_death = challenge.get_node("GuardIsDeath")
onready var gameover_area = challenge.get_node("BG/GameOverArea")
onready var gate_gameover_area = challenge.get_node("BG/GateGameOverArea")


func _ready():
	get_tree().connect("screen_resized", self, "layout")
	layout()


func layout():
	var w = Global.vw.size.x # viewport width
	var h = Global.vw.size.y # viewport height
	var block_size = uto_is_you.get_node("Block4").size # circa 128px

	# make sure w and h are multiples of the block size
	var leftover_x = int(w) % block_size
	var leftover_y = int(h) % block_size
	if leftover_x != 0:
		challenge.position.x = leftover_x / 2
	if leftover_y != 0:
		challenge.position.y = leftover_y / 2
	w -= leftover_x
	h -= leftover_y

	# pawns
	gate.position = block_size / 2 * Vector2.ONE
	uto.position.x = w - uto.size.x / 2
	uto.position.y = h - 200
	settings_icon.position = Vector2(w - 64, h - 64)
	guard1.global_position.x = w - 50
	guard2.global_position.x = guard1.global_position.x - w / 2

	# blocks
	uto_is_you.position.x = w - 3 * block_size
	black_is_poison.position.x = w - 3 * block_size
	center_blocks.position.x = w - 2 * block_size
	center_blocks.position.y = 3 * block_size
	guard_is_death.position.x = block_size
	guard_is_death.position.y = h - 3 * block_size
	text_is_push.position.x = block_size
	text_is_push.position.y = h - 4 * block_size

	# gameover area
	var shape: RectangleShape2D = gameover_area.get_node("CollisionShape2D").shape
	var black_texture_node = challenge.get_node("BG/Ch7Bg")
	var left_spacing = block_size
	shape.extents = Vector2(w / 2 - left_spacing / 2, black_texture_node.texture.get_size().y / 2)
	gameover_area.position.x = w / 2 + left_spacing
	gameover_area.position.y = shape.extents.y / 2 + block_size / 2

	gate_gameover_area.get_node("CollisionShape2D").shape.extents = Vector2(left_spacing, shape.extents.y)
	gate_gameover_area.position.y = gameover_area.position.y
	gate_gameover_area.position.x = leftover_x

	# black graphic
	black_texture.rect_min_size.y = block_size * 3
	ch7bg.set_anchors_and_margins_preset(Control.PRESET_TOP_WIDE)
	ch7bg.rect_min_size.y = ch7bg.texture.get_size().y
	ch7bg.rect_position.y = (block_size * 3) - ch7bg.texture.get_size().y + leftover_y / 2

#	for node in [black_texture, ch7bg]:
#		node.rect_position += Vector2(leftover_x / 2, leftover_y / 2)
