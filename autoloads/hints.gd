extends Node



var challenges_hints: Array = [
	preload("res://autoloads/hints/ch1.tres"),
	preload("res://autoloads/hints/ch2.tres"),
	preload("res://autoloads/hints/ch3.tres"),
	preload("res://autoloads/hints/ch4.tres"),
	preload("res://autoloads/hints/ch5.tres"),
	preload("res://autoloads/hints/ch6.tres"),
	preload("res://autoloads/hints/ch7.tres"),
]

var challenges_sku: Array = []


func _ready():
	challenges_sku = _get_skus()


func _get_skus():
	var skus = []
	for res in challenges_hints:
		var hint_res: HintResource = res
		var hint_skus = {}
		if hint_res.has_hint():
			hint_skus["hint"] = hint_res.hint_sku
		if hint_res.has_full_solution():
			hint_skus["full_solution"] = hint_res.full_solution_sku
		skus.append(hint_skus)
	return skus


func get_hint_resource(ch_num: int) -> HintResource:
	assert(ch_num >= 1 and ch_num <= Global.challenges_count)
	return challenges_hints[ch_num - 1]


func unlock_hint(product_id_sku):
	AndroidPayments.payment.purchase(product_id_sku)


func get_hint(ch_num: int):
	var h = get_hint_resource(ch_num)
	assert(h.has_hint())
	return h.hint


func get_full_solution(ch_num: int):
	var h = get_hint_resource(ch_num)
	assert(h.has_full_solution())
	return h.full_solution


func get_hint_sku_or_null(ch_num):
	ch_num = str(ch_num)
	if challenges_sku.has(ch_num) and challenges_sku[ch_num].has("hint"):
		return challenges_sku[ch_num]["hint"]
	push_warning("challenge {0} does not have a hint sku".format([ch_num]))
	return null


func get_full_solution_sku_or_null(ch_num):
	ch_num = str(ch_num)
	if challenges_sku.has(ch_num) and challenges_sku[ch_num].has("full_solution"):
		return challenges_sku[ch_num]["full_solution"]
	push_warning("challenge {0} does not have a full solution sku".format([ch_num]))
	return null
