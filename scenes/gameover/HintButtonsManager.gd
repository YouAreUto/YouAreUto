extends Node
tool

export(NodePath) onready var hint_button
export(NodePath) onready var full_solution_button
export(NodePath) onready var hints_layer


# TODO: check purchase flow. Do I need to persist any purchase token?

func _get_configuration_warning():
	var msg = ""
	if hint_button == null:
		msg += "Hint Button is not selected.\n"
	if full_solution_button == null:
		msg += "Full Solution Button is not selected.\n"
	if hints_layer == null:
		msg += "Hints Layer is not selected.\n"
	return msg


func _ready():
	if Engine.editor_hint:
		return
	# TODO: handle AndroidPayments.active() == false (eg: unavaible network)
	# var hint_res: HintResource = Hints.get_hint_resource(6)
	if AndroidPayments.active():
		hint_button = get_node(hint_button) as Button
		full_solution_button = get_node(full_solution_button) as Button
		hints_layer = get_node(hints_layer) as ColorRect
		AndroidPayments.connect("product_acquired", self, "on_product_acquired")
		enable_hints()


func on_product_acquired(purchase):
	var sku = purchase.sku
	var hint_res_hint: HintResource = hint_button.get_meta("hint_res")
	var hint_res_full_solution: HintResource = full_solution_button.get_meta("hint_res")

	if hint_res_hint and sku == hint_res_hint.hint_sku:
		unlock_hint(sku)
	elif hint_res_full_solution and sku == hint_res_full_solution.full_solution_sku:
		unlock_solution(sku)


func enable_hints():
	# TODO: check if player already bought the hints
	var ch_num = Global.data.currentChallenge
	var hint = Hints.get_hint_resource(ch_num)
	if hint.has_hint():
		add_hint_button(hint)
	if hint.has_full_solution() or hint.has_full_solution_images():
		add_solution_button(hint)
	# check for unlocked products
	for purchase in AndroidPayments.owned_products:
		if purchase.sku == hint.hint_sku:
			unlock_hint(purchase.sku) # unlock paid content, save token on server, etc.
		elif purchase.sku == hint.full_solution_sku:
			unlock_solution(purchase.sku)
		if !purchase.is_acknowledged:
			push_error("Purchase not acknowledged: not handled")
			# payment.acknowledgePurchase(purchase.purchase_token)
			# Or wait for the _on_purchase_acknowledged callback before giving the user what they bought


func unlock_hint(_hint_sku: String):
	hint_button.text = "SHOW HINT"


func unlock_solution(_solution_sku: String):
	full_solution_button.text = "SHOW FULL SOLUTION"


func add_hint_button(hint_res: HintResource):
	assert(hint_res.has_hint())
	AndroidPayments.payment.querySkuDetails([hint_res.hint_sku], "inapp")
	hint_button.set_meta("hint_res", hint_res)
	hint_button.show()


func add_solution_button(hint_res: HintResource):
	assert(hint_res.has_full_solution() or hint_res.has_full_solution_images())
	AndroidPayments.payment.querySkuDetails([hint_res.full_solution_sku], "inapp")
	full_solution_button.set_meta("hint_res", hint_res)
	full_solution_button.show()


func _on_GetHintButton_pressed():
	var hint_res: HintResource = hint_button.get_meta("hint_res")
	if hint_button.text == "SHOW HINT":
		hints_layer.show_hint(hint_res)
	else:
		Hints.unlock_hint(hint_res.hint_sku)


func _on_GetFullSolutionButton_pressed():
	var hint_res: HintResource = full_solution_button.get_meta("hint_res")
	if full_solution_button.text == "SHOW FULL SOLUTION":
		hints_layer.show_full_solution(hint_res)
	else:
		Hints.unlock_hint(hint_res.full_solution_sku)
