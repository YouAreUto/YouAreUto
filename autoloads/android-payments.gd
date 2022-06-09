# https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html
# https://github.com/godotengine/godot-google-play-billing/blob/master/godot-google-play-billing/src/main/java/org/godotengine/godot/plugin/googleplaybilling/GodotGooglePlayBilling.java
extends Node


var payment


func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")
		print("GodotGooglePlayBilling plugin setup")
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
		print("No GooglePlayBilling singleton")
		push_warning("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work.")


func _on_sku_details_query_error(token_str):
	print("sku_details_query_error", token_str)


func _on_connect_error(err_id, dbg_msg):
	print(err_id, dbg_msg)


func unlock_hint():
	print("unlocking hint")
	var product_id_sku = "test_hint_ch3"
	payment.purchase(product_id_sku)


func _on_purchases_updated(purchases):
	print("purchases updated")
	# TODO: this is just a reference implementation
	for purchase in purchases:
		print("purchase:", purchase)
		if purchase.purchase_state == 1: # 1 means "purchased", see https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState#constants_1
			# enable_premium(purchase.sku) # unlock paid content, add coins, save token on server, etc. (you have to implement enable_premium yourself)
			if not purchase.is_acknowledged:
				payment.acknowledgePurchase(purchase.purchase_token) # call if non-consumable product
#				var list_of_consumable_products = []
#				if purchase.sku in list_of_consumable_products:
#					payment.consumePurchase(purchase.purchase_token) # call if consumable product


func _on_purchase_error(id, msg):
	print("Purchase error")
	print(id, msg)


func _on_purchase_consumed(token):
	print("Purchase consumed ", token)


func _on_purchase_acknowledged(purchase_token):
	print(purchase_token)


func _on_purchase_acknowledgement_error(purchase_token):
	print(purchase_token)


func _on_connected():
	print("Payment connected")
	payment.querySkuDetails(["test_hint_ch3"], "inapp") # "subs" for subscriptions

	yield(get_tree().create_timer(4), "timeout")
	unlock_hint()


func _on_disconnected():
	print("Payment disconnected")


func _on_sku_details_query_completed(sku_details):
	print("available skus")
	print(sku_details)
	for available_sku in sku_details:
		print(available_sku)


func _on_purchase_consumption_error(id, msg, token):
	print("purchase consumption error", id, msg, token)
