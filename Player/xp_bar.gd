extends Control

@export var player: CharacterBody2D
@onready var texture_progress_bar = $TextureProgressBar

func _ready():
	print('CACAAAA')
	print(player.health)
	player.stats_component.health_changed.connect(update)
	update()
	
func update():
	texture_progress_bar.value = player.health
