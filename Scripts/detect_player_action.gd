extends Area2D

@export var ComponentFonctionToCallFrom : Node

func _ready() -> void:
	body_entered.connect(call_function_with_player)

func call_function_with_player(body):
	print_debug("DEBUG")
	ComponentFonctionToCallFrom.call_func(body)
