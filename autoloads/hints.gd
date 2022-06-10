extends Node


var challenges_sku = {
	"3": {
		"hint": "test_ch3_hint",
		"full_solution": "test_ch3_full_solution"
	},
}

var challenges_hints = {
	"3": {
		"hint": "The 2 rows of numbers represent hours and minutes.",
		"full_solution": "The 2 rows of numbers represent hours and minutes. The first row moves every hour; the second row moves every 10 minutes. The numbers in the centre (below “is”) show the current time. Set your phone clock to 3:33 and start again. Now you face no more obstacles! To avoid the rain, get a lift from the servants with umbrellas, and talk to the poet.\nFind out what he has to tell you."
	}
}

func unlock_hint(product_id_sku):
	AndroidPayments.payment.purchase(product_id_sku)


func get_hint(ch_num):
	ch_num = str(ch_num)
	return challenges_hints[ch_num]["hint"]


func get_full_solution(ch_num):
	ch_num = str(ch_num)
	return challenges_hints[ch_num]["full_solution"]


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
