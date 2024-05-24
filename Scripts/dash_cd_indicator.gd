extends Control

@onready var progress_bar: ProgressBar = $TextureRect/ProgressBar
@export var bob : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.max_value = bob.dash_cd


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = bob.dash_timer.get_time_left()
