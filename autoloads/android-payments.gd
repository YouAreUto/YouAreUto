# https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html
# https://github.com/godotengine/godot-google-play-billing/blob/master/godot-google-play-billing/src/main/java/org/godotengine/godot/plugin/googleplaybilling/GodotGooglePlayBilling.java
extends Node

signal update_purchases_buttons()

var payment
var available_purchases = {
	1 : {"full_solution" : "ch1_full_solution"},
	2 : {"full_solution" : "ch2_full_solution"},
	3 : {"full_solution" : "chl3_full_solution", "hint" : "chl3_hint"},
	4 : {"full_solution" : "ch4_full_solution"},
	5 : {"full_solution" : "ch5_full_solution", "hint" : "ch5_hint"},
	6 : {"full_solution" : "ch6_full_solution"},
	7 : {"full_solution" : "ch7_full_solution", "hint" : "ch7_hint"},
}

var current_challenge_solution = null
var current_challenge_hint = null
# You can add products here if it free
var loaded_products = {}
var owned_products = {"ch1_full_solution":{"sku":"ch1_full_solution"}}
var not_acknowledged = {}
enum PurchaseState {
	USPECIFIED_STATE,
	PURCHASED,
	PENDING
}
func _ready():
	
	if Engine.has_singleton("GodotGooglePlayBilling"):
		print("has singleton")
		payment = Engine.get_singleton("GodotGooglePlayBilling")
		payment.connect("connected", self, "_on_connected") # No params
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		payment.connect("disconnected", self, "_on_disconnected") # No params

		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed") # SKUs (Dictionary[])
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.startConnection()
	else:
		print("no singleton")
		push_warning("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")


func load_iaps_data():
	var purch_lst = []
	for challenge in available_purchases:
		for purchase in available_purchases[challenge]:
			purch_lst.append(available_purchases[challenge][purchase])
	payment.querySkuDetails(purch_lst, "inapp")
	
func get_challenge_iap_data(challenge_number):
	
	current_challenge_hint = null
	current_challenge_solution = null
	if challenge_number == 1:  #Free first challeng solution
		current_challenge_solution = owned_products["ch1_full_solution"]
		return
		
	var info = available_purchases[challenge_number]
	if "full_solution" in info and info.full_solution in loaded_products:
		current_challenge_solution = loaded_products[info.full_solution]
	if "hint" in info and info.hint in loaded_products:
		current_challenge_hint = loaded_products[info.hint]
	print("current_challenge_solution")
	print(current_challenge_solution)

	
func _on_sku_details_query_completed(sku_details):
	for i in sku_details:
		loaded_products[i.sku] = i
#		if "solution" in i.sku:
#			current_challenge_solution = i
#		if "hint" in i.sku:
#			current_challenge_hint = i
	print("loaded_products")
	for i in loaded_products:
		print(i)
		print("-----")
#	print_debug(current_challenge_solution)
#	print("-")
#	print_debug(current_challenge_hint)

func _on_connected():
	
	var query = payment.queryPurchases("inapp")
	if query.status == OK:
		check_purchase(query.purchases)
		load_iaps_data()
func purchase(sku):
	payment.purchase(sku)

func _on_purchases_updated(updated_purchases):
	check_purchase(updated_purchases)
			

func check_purchase(purch_list):
	for purchase in purch_list:

		if purchase.purchase_state == PurchaseState.PURCHASED:
			if purchase.is_acknowledged:
				owned_products[purchase.sku] = purchase
			else:
				payment.acknowledgePurchase(purchase.purchase_token)
				not_acknowledged[purchase.purchase_token] = purchase
	emit_signal("update_purchases_buttons")

func _on_purchase_acknowledged(token):
	if token in not_acknowledged:
		owned_products[not_acknowledged[token].sku] = not_acknowledged[token]
	emit_signal("update_purchases_buttons")
	
