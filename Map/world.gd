extends Node2D

@onready var level_up_menu: Control = $"MenuLayer/Level Up Menu"
@onready var bob: CharacterBody2D = $Bob
@onready var pause = $PauseLayer/MenuPause
@onready var sound_game: AudioStreamPlayer2D = $sound_game
const boss = preload("res://Boss/atilla.tscn")
var boss_here = false


func _ready() -> void:
	Global.kill_count = 0

func pauseMenu():
	if Global.paused:
		get_tree().paused = false
		pause.hide()
	else:
		get_tree().paused = true
		pause.show()
		pause.button.grab_focus()
	Global.paused = !Global.paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		level_up_menu._on_lvl_up()
		
	if Input.is_action_just_pressed("ECHAP"):
		pauseMenu()
		
	if Input.is_action_just_pressed("ui_spawn_boss"):
		var boss_spawn = boss.instantiate()
		boss_spawn.position = Vector2(bob.position.x + 100, bob.position.y + 100)
		add_child(boss_spawn)
	
	if not boss_here and search_boss() and bob.health > 0:
		sound_game.stop()
		boss_here = true
	elif boss_here and not search_boss() and bob.health > 0:
		sound_game.play(0.0 )
		boss_here = false

func search_boss():
	for child in get_children():
		if child.name == "Atilla":
			return true
	return false
