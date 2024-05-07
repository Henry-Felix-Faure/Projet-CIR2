extends CharacterBody2D

var health: int = 100
var speed: float = 600.0
var attack_damage: int = 20
var attackInterval : float = 2.0
const expScene = preload("res://experience.tscn")

@onready var range: Area2D = $range
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_node("/root/World/player")
@onready var wait_timer: Timer = $Timer
var wait : bool = false
var in_area : bool = false

func _ready():
	wait_timer.wait_time = attackInterval
	range.body_entered.connect(_on_range_body_entered)
	range.body_exited.connect(_on_range_body_exited)
	
func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()


func die() -> void:
	var exp = expScene.instantiate()
	exp.position = position
	get_tree().current_scene.add_child(exp)
	queue_free()
	


func attack() -> void:
	#damage le joueur
	animated_sprite_2d.play("attack")
	wait_timer.start()
	wait = true


func _physics_process(delta):
	if(!wait):
		animated_sprite_2d.play("move")
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed * delta * 5
	move_and_slide()


func _on_range_body_entered(body):
	attack()
	in_area = true
	
func _on_range_body_exited(body):
	in_area = false

func _on_timer_timeout() -> void:
	wait = false
	if in_area:
		attack()
