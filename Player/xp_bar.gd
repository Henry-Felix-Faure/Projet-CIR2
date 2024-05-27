extends Control

@export var player: CharacterBody2D
@onready var texture_progress_bar = $TextureProgressBarxp

func _ready():
	player.stats_component.stat_changed.connect(update)
	update()
	
func update():
	texture_progress_bar.max_value = player.xp_lvl_up
	texture_progress_bar.value = player.xp
