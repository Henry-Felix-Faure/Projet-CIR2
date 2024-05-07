extends AnimatedSprite2D

@onready var detect_action_player: Area2D = $DetectActionPlayer
@onready var player = get_node("../Player")
@onready var ennemies_stats_component: EnnemiesStatsComponent = $EnnemiesStatsComponent

func _process(delta):
	position = position.move_toward(player.position, delta*ennemies_stats_component.SPEED)
