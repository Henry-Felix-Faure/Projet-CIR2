extends CharacterBody2D

@onready var player = get_parent().get_node("Bob")


func _ready() -> void:
	print_debug(player)
