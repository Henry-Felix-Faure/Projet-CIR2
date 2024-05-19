extends CharacterBody2D

var nb_exp: float = 10.0
var bonus_ramassage: bool = true

@onready var animation: AnimatedSprite2D = $animexp
@onready var player = get_node("/root/World/player")
@onready var range_exp: Area2D = $range_exp

func _ready() -> void:
	animation.play("exp")
	range_exp.body_entered.connect(_on_range_body_entered)

func _on_range_body_entered(body) -> void:
	die()

func die() -> void:
	player.get_child(6).xp += nb_exp
	queue_free()

func _physics_process(delta):
	if bonus_ramassage :
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 10000 * delta
		move_and_slide()
