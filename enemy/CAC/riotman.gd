extends CharacterBody2D

@export var stats: EnnemiesStatsComponent

var speed: float = 30.0

const expScene = preload("res://experience/experience.tscn")

@onready var range: Area2D = $range
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_node("/root/World/Bob")
@onready var wait_timer: Timer = $Timer
var wait : bool = false
var in_area : bool = false

func _ready():
	var attackInterval = stats.ATK_SPEED
	wait_timer.wait_time = attackInterval / 50
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
		
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false

func _on_range_body_entered(body):
	attack()
	in_area = true
	
func _on_range_body_exited(body):
	in_area = false


func _on_timer_timeout() -> void:
	wait = false
	if in_area:
		attack()
