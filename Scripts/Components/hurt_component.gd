# Give the component a class name so it can be instanced as a custom node
class_name HurtComponent
extends Node

# Grab the stats so we can alter the health
@export var stats_component: StatsComponent

# Grab a hurtbox so we know when we have taken a hiet
@export var hurtbox_component: HurtboxComponent

signal critical_hit

func shader_wait(seconds: float, entity) -> void: # custom wait function
	await get_tree().create_timer(seconds).timeout
	entity.get_node("AnimatedSprite2D").material.set_shader_parameter("shake_power", float(0.0))
	entity.get_node("AnimatedSprite2D").material.set_shader_parameter("shake_color_rate", float(0.0))

func _ready() -> void:
	var player = 0
	var entity = 0
	# Connect the hurt signal on the hurtbox component to an anonymous function
	# that removes health equal to the damage from the hitbox
	if(get_parent().name == "Bob"):
		player = get_parent()
	else:
		entity = get_parent()
	
	hurtbox_component.hurt.connect(func(hitbox_component: HitboxComponent, crit : bool):
		if crit:
			entity.get_node("AnimatedSprite2D").material.set_shader_parameter("shake_power", float(0.03))
			entity.get_node("AnimatedSprite2D").material.set_shader_parameter("shake_color_rate", float(0.02))
			shader_wait(0.1, entity)
			critical_hit.emit()
		if player and player.parrying:
			if player.last_dir.x > 0 and (hitbox_component.get_parent().position.x > player.position.x):
				player.explosion_particles.position = Vector2(8,0)
				successful_parry(player, player.parry_lvl)
			elif player.last_dir.x < 0 and (hitbox_component.get_parent().position.x < player.position.x):
				player.explosion_particles.position = Vector2(-8,0)
				successful_parry(player, player.parry_lvl)
			elif player.last_dir.y > 0 and (hitbox_component.get_parent().position.y > player.position.y):
				player.explosion_particles.position = Vector2(0,-7)
				successful_parry(player, player.parry_lvl)
			elif player.last_dir.y < 0 and (hitbox_component.get_parent().position.y < player.position.y):
				player.explosion_particles.position = Vector2(0,-11)
				successful_parry(player, player.parry_lvl)
			else:
				stats_component.health -= hitbox_component.damage
				if hitbox_component.get_parent().name == "BulletToPlayer":
					hitbox_component.get_parent().queue_free()
		elif player and player.dashing:
			pass
		else:
			stats_component.health -= hitbox_component.damage
			if hitbox_component.get_parent().name == "BulletToPlayer":
				hitbox_component.get_parent().queue_free()
	)

func successful_parry(player, parry_lvl: int):
	player.get_node("audio_parry").play()
	player.explosion_particles.direction = player.last_dir
	player.explosion_particles.emitting = true
	player.get_node("Camera2D").shake(0.2, 3)
