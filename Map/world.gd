extends Node2D

@onready var level_up_menu: Control = $"MenuLayer/Level Up Menu"
@onready var bob: CharacterBody2D = $Bob


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		bob.get_child(6).xp += 1
	
