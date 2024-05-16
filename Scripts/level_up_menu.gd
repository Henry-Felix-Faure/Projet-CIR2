extends Control

@export var level_up_tree: LevelUpTree 
@onready var choice_1: Button = $PanelContainer/VBoxContainer/Choice1
@onready var choice_2: Button = $PanelContainer/VBoxContainer/Choice2
@onready var choice_3: Button = $PanelContainer/VBoxContainer/Choice3

@onready var all_buttons : Array = [choice_1, choice_2, choice_3]

var choice1 : Array
var choice2 : Array
var choice3 : Array

func _ready() -> void:
	hide()
	_on_lvl_up()
	
func _on_lvl_up():
	choice1 = level_up_tree._GetUpgrade()
	choice2 = choice1
	choice3 = choice1
	while(choice2 == choice1):
		choice2 = level_up_tree._GetUpgrade()
	while(choice3 == choice1 or choice3 == choice2):
		choice3 = level_up_tree._GetUpgrade()
	var all_choices = [choice1,choice2,choice3]
	for i in range(0,3):
		var button = all_buttons[i] as Button
		var choice = all_choices[i]
		var item = choice[0][choice[1]]
		button.text = item["name"]
		button.get_child(0).text = item["desc"]
	get_tree().paused = true
	show()

func _on_choice_1_pressed() -> void:
	var item = choice1[0][choice1[1]]
	item["call"].call(item["value"])
	choice1[1] += 1
	get_tree().paused = false
	hide()

func _on_choice_2_pressed() -> void:
	var item = choice2[0][choice2[1]]
	item["call"].call(item["value"])
	get_tree().paused = false
	choice2[1] += 1
	hide()
	
func _on_choice_3_pressed() -> void:
	var item = choice3[0][choice3[1]]
	item["call"].call(item["value"])
	choice3[1] += 1
	get_tree().paused = false
	hide()
