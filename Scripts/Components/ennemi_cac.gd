class_name EnnemiCacBehaviourComponent
extends CharacterBody2D

@export var health: int = 100
@export var speed: float = 100.0
@export var attack_damage: int = 20
@export var attack_range: float = 50.0

var player: Node2D   
var is_attacking: bool = false


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()


func die() -> void:
	queue_free()  


func attack() -> void:
	if player and global_position.distance_to(player.global_position) <= attack_range:
		is_attacking = true
		player.take_damage(attack_damage)  
	else:
		is_attacking = false


func move_towards_player(delta) -> void:
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed * delta
		


func _process(delta: float) -> void:
	move_towards_player(delta)
	attack()
