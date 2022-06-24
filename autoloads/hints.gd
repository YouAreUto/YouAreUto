extends Node


var challenges_sku = {
	"3": {
		"hint": "test_ch3_hint",
		"full_solution": "test_ch3_full_solution"
	},
}

var challenges_hints = {
	"1": {
		"full_solution": "The herald says that guards protect the king at all times. Kill the herald (just drag Uto against him) and this rule disappears. The king is no longer well-protected. Wait for an opening and kill him."
	},
	"2": {
		"full_solution": "Push the blue text up. The rule changes and now you are (definitely) a castle servant. Guards don’t kill you anymore (guards kill Uto…). Go to Settings, switch the color off, and go back. There is no red text (barrier) anymore and you can enter the castle."
	},
	"3": {
		"hint": "The 2 rows of numbers represent hours and minutes.",
		"full_solution": "The 2 rows of numbers represent hours and minutes. The first row moves every hour, the second row moves every 10 minutes. The numbers in the center (below “is”) show the current time. Set your phone clock to 3:33 and start again. Now you no logner face a barrier! To avoid the rain, get a lift from the servants with umbrellas and talk to the poet.\nFind out what he has to tell you."
	},
	"4": {
		"full_solution": "You are just a number. Drag the number 4 and push the blue text “to win” between the two red lines. Now push the blue text “red text” over the words “blue text.” The rule changes and now is the red text can be pushed. Push “drag Uto here” and align it to “to win.” This is it! Uto is where it needs to be to win this challenge."
	},
	"5": {
		"hint": "It’s dark. You need light to see.",
		"full_solution": "It’s dark, turn your phone’s flashlight on! Uto walks on black, so drag Uto over “black” and get the key. Now you need to slow the guards down as their movement prevent you from reaching the chest. Go to Settings, set the guard speed to 0.5 and go back. Wait for a good moment, drag Uto over “black” again and open the chest!"
	},
	"6": {
		"full_solution": "Interacting with the other characters creates the rules necessary to win. But it needs to be done in the right order while avoiding the castle servant and the guards (only when you are with Ota). Talk to a guard, then to the captain, then to Ota, and finally to the poet. After you talk to the poet, the “all text is a barrier” rule is created in the right position. This affects the guards’ movement and gives you the opportunity to reach the captain (with Ota) without being killed. You just helped Ota leave town won this challenge!"
	},
	"7": preload("res://autoloads/hints/ch7.tres")
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
