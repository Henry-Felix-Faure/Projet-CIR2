extends Control

var boss: CharacterBody2D
@onready var texture_progress_bar = $TextureProgressBarBoss

func _ready():
	boss.stats_component.stat_changed.connect(update)
	update()
	
func update():
	texture_progress_bar.max_value = boss.stats_component.max_health
	texture_progress_bar.value = boss.stats_component.health
