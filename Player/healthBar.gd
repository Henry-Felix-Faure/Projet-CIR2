extends Control

@export var player: CharacterBody2D
@onready var texture_progress_bar = $TextureProgressBar

func _ready():
	player.stats_component.stat_changed.connect(update)
	update()
	
func update():
	texture_progress_bar.max_value = player.max_health
	texture_progress_bar.value = player.health
