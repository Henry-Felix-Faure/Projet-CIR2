extends Node2D

@onready var level_up_menu: Control = $"MenuLayer/Level Up Menu"
@onready var bob: CharacterBody2D = $Bob
@onready var pause = $PauseLayer/MenuPause

func pauseMenu():
	if Global.paused:
		get_tree().paused = false
		pause.hide()
	else:
		get_tree().paused = true
		pause.show()

	Global.paused = !Global.paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		level_up_menu._on_lvl_up()
		
	if Input.is_action_just_pressed("ECHAP"):
		pauseMenu()
