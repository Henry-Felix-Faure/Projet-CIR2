class_name XP
extends CharacterBody2D

var nb_exp: float = 50.0
var bonus_ramassage: bool = false 


@onready var animation: AnimatedSprite2D = $anim_xp
@onready var player = get_node("/root/World/Bob")
@onready var Stats = player.get_child(10)
@onready var range_exp: Area2D = $range_exp

func _ready() -> void:
	if nb_exp < 30 :
		animation.play("exp1")
	elif nb_exp >= 30 and nb_exp < 60:
		animation.play("exp2")
	else:
		animation.play("exp3")
	range_exp.body_entered.connect(_on_range_body_entered)

func _on_range_body_entered(_body) -> void:
	die()

func die() -> void:
	Stats.xp += nb_exp
	queue_free()

func _physics_process(delta):
	if bonus_ramassage :
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 5000 * delta
		move_and_slide()
