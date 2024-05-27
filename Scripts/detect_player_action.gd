extends Area2D

@export var ComponentFonctionToCallFrom : Node
@export var AttackSpeed : Timer
signal player_in
signal player_out

func _ready() -> void:
	pass
	
func call_function_with_player(body):
	if(AttackSpeed.get_time_left() == 0):
		ComponentFonctionToCallFrom.call_func(body)
