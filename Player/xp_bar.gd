extends Control

@export var player: CharacterBody2D
@onready var texture_progress_bar = $TextureProgressBarxp

func _ready():
	player.stats_component.health_changed.connect(update)
	update()
	
func update():
	texture_progress_bar.value = player.xp
