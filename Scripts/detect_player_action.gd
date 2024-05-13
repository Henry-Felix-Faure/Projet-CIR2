extends Area2D

@export var ComponentFonctionToCallFrom : Node
signal player_in
signal player_out

func _ready() -> void:
	body_entered.connect(call_function_with_player)
	
func call_function_with_player(body):
	ComponentFonctionToCallFrom.call_func(body)

