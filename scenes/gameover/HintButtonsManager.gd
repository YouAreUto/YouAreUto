extends Node
tool

export(NodePath) onready var hint_button
export(NodePath) onready var full_solution_button
export(NodePath) onready var hints_layer
onready var hint_button_node = get_node(hint_button)
onready var full_solution_button_node = get_node(full_solution_button)

var hint_purchased = false
var full_purchased = false

func _ready():

	AndroidPayments.connect("update_purchases_buttons", self, "update_purchases_buttons")
	if Engine.editor_hint:
		return
	update_purchases_buttons()
	
	
	
func update_purchases_buttons():
	print(AndroidPayments.owned_products)
	print("UPDATE")
	hint_button_node.visible = !Global.isnull(AndroidPayments.current_challenge_hint)
	full_solution_button_node.visible = !Global.isnull(AndroidPayments.current_challenge_solution)
	var current_hint = AndroidPayments.current_challenge_hint
	var full_solution = AndroidPayments.current_challenge_solution
	
	if !Global.isnull(current_hint):
		
		if current_hint.sku in AndroidPayments.owned_products:
			hint_button_node.set_text("SHOW HINT")
			hint_purchased = true
		else:
			var hint_price = str(current_hint.original_price_amount_micros / 1000000.0) + \
							" " + current_hint.price_currency_code
			hint_button_node.set_text("GET A HINT " + hint_price)
			hint_purchased = false
			
	if !Global.isnull(full_solution):
		if full_solution.sku in AndroidPayments.owned_products:
			full_solution_button_node.set_text("SHOW SOLUTION")
			full_purchased = true
		else:
			var full_solution_price = str(full_solution.original_price_amount_micros / 1000000.0) + \
							" " + full_solution.price_currency_code
			full_solution_button_node.set_text("GET THE FULL SOLUTION " + full_solution_price)
			full_purchased = false





func _on_GetHintButton_pressed():
	if !hint_purchased:
		AndroidPayments.purchase(AndroidPayments.current_challenge_hint.sku)
	else:
		get_node(hints_layer).show_hint(Hints.challenges_hints[Global.data.currentChallenge - 1])


func _on_GetFullSolutionButton_pressed():
	if !full_purchased:
		AndroidPayments.purchase(AndroidPayments.current_challenge_solution.sku)
	else:
		get_node(hints_layer).show_full_solution(Hints.challenges_hints[Global.data.currentChallenge - 1])
