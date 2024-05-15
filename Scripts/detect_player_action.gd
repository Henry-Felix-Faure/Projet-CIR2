extends Area2D

@export var ComponentFonctionToCallFrom : Node
@export var AttackSpeed : Timer
signal player_in
signal player_out

func _ready() -> void:
	body_entered.connect(call_function_with_player)
	
func call_function_with_player(body):
	if(AttackSpeed.get_time_left() == 0):
		ComponentFonctionToCallFrom.call_func(body)
