extends Control

signal choosen


func _ready() -> void:
	add_to_group("DroneMenu")
	hide()

func show_drone_menu():
	get_tree()
	show()
	

func _on_choice_1_pressed() -> void:
	choosen.emit(1)
	queue_free()


func _on_choice_2_pressed() -> void:
	choosen.emit(4)
	queue_free()


func _on_choice_3_pressed() -> void:
	choosen.emit(7)
	queue_free()
