extends Control

var Boss: CharacterBody2D
@onready var texture_progress_bar = $TextureProgressBarBoss

func _ready():
	update()
	
func update():
	texture_progress_bar.max_value = Boss.stats_component.max_health
	texture_progress_bar.value = Boss.stats_component.health
