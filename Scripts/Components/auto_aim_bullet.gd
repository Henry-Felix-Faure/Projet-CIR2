class_name AutoAimBullet
extends Node

@export var spawn_component : SpawnComponent
@export var ennemies_stats : EnnemiesStatsComponent

func call_func(body : Node2D) -> void:
	var player_pos : Vector2 = body.global_position
	var bullet : Node2D = spawn_component.spawn(get_parent().global_position)
	var v = player_pos - bullet.global_position
	var angle = v.angle()
	bullet.set_layer(2)
	bullet.rotation = angle
	bullet.damage = ennemies_stats.DAMMAGE
	
