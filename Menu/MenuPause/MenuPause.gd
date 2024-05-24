extends Control

@onready var main = $"../../"

func _on_button_pressed():
	main.pauseMenu()

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Menu/MenuStart/MenuStart.tscn")
