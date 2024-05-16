extends Node2D

@onready var level_up_menu: Control = $"MenuLayer/Level Up Menu"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		level_up_menu._on_lvl_up()
	
