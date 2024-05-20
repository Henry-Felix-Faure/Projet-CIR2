extends Control

@onready var line_edit = $VBoxContainer/LineEdit
@onready var solo_button = $HBoxContainer/Solo
@onready var multijoueur_button = $HBoxContainer/Multijoueur
var txt   = ""

func _ready():
	# Désactiver les boutons au début
	solo_button.disabled = true
	multijoueur_button.disabled = true


func _on_solo_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


func _on_line_edit_text_submitted(_new_text):
	pass


func _on_line_edit_text_changed(new_text):
	solo_button.disabled = new_text == ""
	multijoueur_button.disabled = new_text == ""
	txt = new_text


func _on_multijoueur_pressed():
	pass
