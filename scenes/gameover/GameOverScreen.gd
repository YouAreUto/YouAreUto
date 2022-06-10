extends Node2D

onready var text := $CanvasLayer/Text
onready var hint_button := $CanvasLayer/VBoxContainer/GetHintButton
onready var full_solution_button := $CanvasLayer/VBoxContainer/GetFullSolutionButton
onready var hints_layer := $CanvasLayer/HintsLayer

var use_legacy_code = true


# TODO: check purchase flow. Do I need to persist any purchase token?

func _ready():
	# TODO: handle AndroidPayments.active() == false (eg: unavaible network)
	if AndroidPayments.active():
		AndroidPayments.connect("product_acquired", self, "on_product_acquired")
		enable_hints()
	setPositions()
	Global.challengeData = {}


func on_product_acquired(purchase):
	var sku = purchase.sku
	if sku == hint_button.get_meta("hint_sku"):
		unlock_hint(sku)
	elif sku == full_solution_button.get_meta("solution_sku"):
		unlock_solution(sku)


func enable_hints():
	# TODO: check if player already bought the hints
	var ch_num = Global.data.currentChallenge
	var hint_sku = Hints.get_hint_sku_or_null(ch_num)
	var solution_sku = Hints.get_full_solution_sku_or_null(ch_num)

	if hint_sku:
		add_hint_button(hint_sku)
	if solution_sku:
		add_solution_button(solution_sku)

	for purchase in AndroidPayments.owned_products:
		if purchase.sku == hint_sku:
			unlock_hint(purchase.sku) # unlock paid content, save token on server, etc.
		elif purchase.sku == solution_sku:
			unlock_solution(purchase.sku)
		if !purchase.is_acknowledged:
			push_error("Purchase not acknowledged: not handled")
			# payment.acknowledgePurchase(purchase.purchase_token)
			# Or wait for the _on_purchase_acknowledged callback before giving the user what they bought


func unlock_hint(hint_sku):
	hint_button.text = "SHOW HINT"


func unlock_solution(solution_sku):
	full_solution_button.text = "SHOW FULL SOLUTION"


func add_hint_button(hint_sku):
	AndroidPayments.payment.querySkuDetails([hint_sku], "inapp")
	hint_button.set_meta("hint_sku", hint_sku)
	hint_button.show()


func add_solution_button(solution_sku):
	AndroidPayments.payment.querySkuDetails([solution_sku], "inapp")
	full_solution_button.set_meta("solution_sku", solution_sku)
	full_solution_button.show()


func init(conf: Dictionary):
	if conf.has("text"):
		text.text = conf.text
	if conf.has("hideQuitButton"):
		$CanvasLayer/VBoxContainer/QuitButton.hide()
	if conf.has("use_legacy_code"):
		use_legacy_code = conf.get("use_legacy_code")


func setPositions():
	text.rect_position.x = get_viewport_rect().size.x * 0.5 - text.rect_size.x / 2


func _on_QuitButton_pressed():
	SceneManager.goto_scene("res://scenes/MainMenu/MainMenu.tscn")


func _on_RestartButton_pressed():
	if use_legacy_code:
		SceneManager.goto_scene(Global.getChallengePath(Global.data.currentChallenge).intro)
	else:
		SceneManager.restart_challenge()


func _on_GetHintButton_pressed():
	var hint_sku = hint_button.get_meta("hint_sku")
	if hint_button.text == "SHOW HINT":
		hints_layer.show_hint(hint_sku, "hint")
	else:
		Hints.unlock_hint(hint_sku)


func _on_GetFullSolutionButton_pressed():
	var solution_sku = full_solution_button.get_meta("solution_sku")
	if full_solution_button.text == "SHOW FULL SOLUTION":
		hints_layer.show_hint(solution_sku, "full_solution")
	else:
		Hints.unlock_hint(solution_sku)
