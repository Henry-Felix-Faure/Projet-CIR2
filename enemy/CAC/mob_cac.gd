extends CharacterBody2D

var health: int = 100
var speed: float = 60.0
var attack_damage: int = 20
var attackInterval : float = 2.0
const expScene = preload("res://experience/experience.tscn")

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



func attack() -> void:
	animated_sprite_2d.play("attack")
	wait_timer.start()
	wait = true


func _physics_process(delta):
	if(!wait):
		animated_sprite_2d.play("move")
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed * delta 
	move_and_collide(velocity)


func _on_range_body_entered(body):
	attack()
	in_area = true
	
func _on_range_body_exited(body):
	in_area = false

func _on_timer_timeout() -> void:
	wait = false
	if in_area:
		attack()
