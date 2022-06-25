# https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html
# https://github.com/godotengine/godot-google-play-billing/blob/master/godot-google-play-billing/src/main/java/org/godotengine/godot/plugin/googleplaybilling/GodotGooglePlayBilling.java
extends Node

signal product_acquired(sku)

# https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState?hl=en#summary
enum PurchaseState {
	USPECIFIED_STATE,
	PURCHASED,
	PENDING
}

var payment
var state = "disabled"
var owned_products = [] # Purchase[]

#class Purchase:
#	var sku: String
#	var is_acknowledged: bool
#	var is_auto_renewing: bool
#	var order_id: String
#	var package_name: String
#	var purchase_state: int
#	var purchase_time: int
#	var signature: String


func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
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
		push_warning("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")


func active():
	return state == "connected"


func check_purchase():
	var query = payment.queryPurchases("inapp")
	if query.status == OK:
		for purchase in query.purchases:
			# print(purchase.sku, "purchased: ", purchase.purchase_state == PurchaseState.PURCHASED, " is_acknowledged: ", purchase.is_acknowledged)
			if purchase.purchase_state == PurchaseState.PURCHASED:
				owned_products.append(purchase)


func _on_sku_details_query_error(response_id, message, queried_skus):
	print("sku_details_query_error", response_id, message, queried_skus)


func _on_connected():
	state = "connected"
	print("Payment connected")
	check_purchase()


func _on_connect_error(err_id, dbg_msg):
	push_error("{0} {1}".format([err_id, dbg_msg]))


func _on_disconnected():
	state = "disconnected"
	push_warning("Payment disconnected")


func _on_purchases_updated(purchases):
	print("purchases updated")
	for purchase in purchases:
		if purchase.purchase_state == PurchaseState.PURCHASED:
			if not owned_products_contain(purchase.sku):
				owned_products.append(purchase)
			emit_signal("product_acquired", purchase)
			if not purchase.is_acknowledged:
				payment.acknowledgePurchase(purchase.purchase_token) # call for non-consumable products


func _on_purchase_error(id, msg):
	push_error("Purchase error {0} {1}".format([id, msg]))


func _on_purchase_consumed(token):
	print("Purchase consumed ", token)


func _on_purchase_acknowledged(purchase_token):
	print("purchase acnowledged ", purchase_token)


func _on_purchase_acknowledgement_error(purchase_token):
	push_error("purchase acknowledgement error {0}".format([purchase_token]))


func _on_sku_details_query_completed(sku_details):
	for sku in sku_details:
		print("sku details: {0} {1}".format([sku.title, sku.description]))


func _on_purchase_consumption_error(id, msg, token):
	push_error("purchase consumption error {0} {1} {2}".format([id, msg, token]))


func owned_products_contain(sku):
	for p in owned_products:
		if p.sku == sku:
			return true
	return false

