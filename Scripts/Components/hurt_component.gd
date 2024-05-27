# Give the component a class name so it can be instanced as a custom node
class_name HurtComponent
extends Node

# Grab the stats so we can alter the health
@export var stats_component: StatsComponent

# Grab a hurtbox so we know when we have taken a hit
@export var hurtbox_component: HurtboxComponent

@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

signal critical_hit
@onready var flash_timer = Timer.new()
@onready var glitch_timer = Timer.new()

func _ready() -> void:
	flash_timer.wait_time = 0.12
	add_child(flash_timer)
	flash_timer.timeout.connect(_on_flash_timer_timeout)
	flash_timer.one_shot = true
	glitch_timer.wait_time = 0.12
	add_child(glitch_timer)
	glitch_timer.timeout.connect(_on_glitch_timer_timeout)
	glitch_timer.one_shot = true
	var player = 0
	var entity = 0

	if(get_parent().name == "Bob"):
		player = get_parent()
	else:
		entity = get_parent()
	
	hurtbox_component.hurt.connect(func(hitbox_component: HitboxComponent, crit : bool = false):
		print(hitbox_component.get_parent().name, " -> ", hurtbox_component.get_parent().name)
		if crit:
			glitch(entity)
			critical_hit.emit()
		if player and player.parrying and hitbox_component.get_parent().name != "kamikaze":
			if player.last_dir.x > 0 and (hitbox_component.get_parent().position.x > player.position.x):
				player.explosion_particles.position = Vector2(8,0)
				successful_parry(player, hitbox_component)
			elif player.last_dir.x < 0 and (hitbox_component.get_parent().position.x < player.position.x):
				player.explosion_particles.position = Vector2(-8,0)
				successful_parry(player, hitbox_component)
			elif player.last_dir.y > 0 and (hitbox_component.get_parent().position.y > player.position.y):
				player.explosion_particles.position = Vector2(0,-7)
				successful_parry(player, hitbox_component)
			elif player.last_dir.y < 0 and (hitbox_component.get_parent().position.y < player.position.y):
				player.explosion_particles.position = Vector2(0,-11)
				successful_parry(player, hitbox_component)
			else:
				stats_component.health -= hitbox_component.damage
				if hitbox_component.get_parent().name == "BulletToPlayer" or hitbox_component.get_parent().name == "BossBullet":
					hitbox_component.get_parent().queue_free()
		elif player and player.dashing:
			pass
		else:
			flash()
			if (hitbox_component.get_parent().name == "Robot" or hitbox_component.get_parent().name == "policeman" or hitbox_component.get_parent().name == "riotman"):
				if not(hitbox_component.get_parent().has_input_dmg):
					stats_component.health -= hitbox_component.damage
					hitbox_component.get_parent().has_input_dmg = true
					return
				else:
					return
			if hitbox_component.get_parent().name == "BulletToPlayer":
				stats_component.health -= hitbox_component.damage
				hitbox_component.get_parent().queue_free()
				return
			if hitbox_component.get_parent().name == "BossBullet":
				stats_component.health -= hitbox_component.damage
				if not(hitbox_component.get_parent().turning):
					hitbox_component.get_parent().queue_free()
				
			stats_component.health -= hitbox_component.damage
	)

func successful_parry(player: CharacterBody2D, hitbox_component: HitboxComponent):
	player.get_node("audio_parry").play()
	player.explosion_particles.direction = player.last_dir
	player.explosion_particles.emitting = true
	player.get_node("Camera2D").shake(0.2, 3)
	
	if hitbox_component.get_parent().name == "BulletToPlayer" or hitbox_component.get_parent().name == "BossBullet":
		var bullet = hitbox_component.get_parent()
		var parry_lvl: int = player.parry_lvl
		match parry_lvl:
			1:
				bullet.get_node("AnimatedSprite2D").play("destroy")
				await bullet.get_node("AnimatedSprite2D").animation_finished
				bullet.queue_free()
			2:
				if player.last_dir.x:
					bullet.rotation = bullet.rotation * (-1.0) + PI
				else:
					bullet.rotation = (bullet.rotation - PI * player.last_dir.y) * (-1.0) + PI
			3:
				bullet.rotation += PI
	
		bullet.hitbox_component.set_collision_layer_value(3, false)
		bullet.hitbox_component.set_collision_mask_value(2, false)
		bullet.hitbox_component.set_collision_mask_value(3, true)


func glitch(entity):
	entity.get_node("AnimatedSprite2D").material.set_shader_parameter("is_flash",0)
	entity.get_node("AnimatedSprite2D").material.set_shader_parameter("shake_rate", float(1.0))
	entity.get_node("AnimatedSprite2D").material.set_shader_parameter("shake_power", float(0.04))
	entity.get_node("AnimatedSprite2D").material.set_shader_parameter("shake_color_rate", float(0.01))
	glitch_timer.start()

func flash():
	animated_sprite_2d.material.set_shader_parameter("flash_modifier",1)
	flash_timer.start()

func _on_flash_timer_timeout() -> void:
	animated_sprite_2d.material.set_shader_parameter("flash_modifier",0)

func _on_glitch_timer_timeout() -> void:
	animated_sprite_2d.material.set_shader_parameter("shake_power", float(0.0))
	animated_sprite_2d.material.set_shader_parameter("shake_rate", float(0.0))
	animated_sprite_2d.material.set_shader_parameter("shake_color_rate", float(0.0))
	animated_sprite_2d.material.set_shader_parameter("is_flash",1)
