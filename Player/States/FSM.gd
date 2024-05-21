class_name FSM
extends Node

var states : Dictionary = {}
@export var initial_state : State
var current_state : State
@export var animated_sprite2D : AnimatedSprite2D
@onready var bob: CharacterBody2D = $".."

func _ready():
	animated_sprite2D.animation_finished.connect(_on_animation_finished)
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
		
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func change_state(old_state : State, new_state_name : String):
	if old_state != current_state:
		print("bizarre")
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("New state is empty")
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
	
func _on_animation_finished():
	if current_state and current_state.has_method("animation_finished"): 
		current_state.animation_finished()

func is_attack_crit() -> bool:
	var rd_float: float = randf()
	if rd_float <= bob.crit_chance:
		bob.sword_area_2d.damage = ceil(bob.damage * bob.crit_damage)
		bob.sword_area_2d.critical = 1
		return true
	else:
		bob.sword_area_2d.damage = bob.damage
		bob.sword_area_2d.critical = 0
		return false

func wait(seconds: float) -> void: # custom wait function
	await get_tree().create_timer(seconds).timeout

func _on_stats_component_no_health() -> void:
	change_state(current_state, "DYING")
