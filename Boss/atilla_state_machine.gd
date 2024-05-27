extends Node

var states : Dictionary = {}
@export var initial_state : State
var current_state : State

@onready var atilla: CharacterBody2D = $".."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var aoe_cd: Timer = $"../AOE_cd"
@onready var atk_cd: Timer = $"../Atk_cd"


func _ready():
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
		print("State not correct")
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
