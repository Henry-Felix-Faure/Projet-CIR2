extends CharacterBody2D

@export var stats: EnnemiesStatsComponent
@export var hurtbox_component: HurtboxComponent

var speed: float = 30.0

const expScene = preload("res://experience/experience.tscn")

@onready var knife: AudioStreamPlayer2D = $knife


@onready var detection_r: CollisionShape2D = $range/DetectionR
@onready var detection_l: CollisionShape2D = $range/DetectionL
@onready var range: Area2D = $range
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_node("/root/World/Bob")
@onready var wait_timer: Timer = $Timer
@onready var attack_l: CollisionShape2D = $HitboxComponent/AttackL
@onready var attack_r: CollisionShape2D = $HitboxComponent/AttackR

@onready var has_input_dmg: bool = false
var wait : bool = false
var in_area : bool = false
var direction : Vector2

func _ready():
	attack_l.set_deferred("disabled", true)
	attack_r.set_deferred("disabled", true)
	var attackInterval = stats.ATK_SPEED
	wait_timer.wait_time = attackInterval / 50
	hurtbox_component.hurt.connect(_hurt)
	range.body_entered.connect(_on_range_body_entered)
	range.body_exited.connect(_on_range_body_exited)


func attack() -> void:
	if direction.x > 0:
		attack_r.set_deferred("disabled", false)
	else:
		attack_l.set_deferred("disabled", false)
	knife.play()
	animated_sprite_2d.play("attack")
	wait = true
	await animated_sprite_2d.animation_finished
	attack_l.set_deferred("disabled", true)
	attack_r.set_deferred("disabled", true)
	if in_area:
		wait_timer.start()
	else:
		wait = false

func _physics_process(delta):
	if(!wait):
		animated_sprite_2d.play("move")
		direction = global_position.direction_to(player.global_position)
		velocity = direction * speed * delta 
		move_and_collide(velocity)
	
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
			detection_r.disabled = true
			detection_l.disabled = false
			
		else:
			animated_sprite_2d.flip_h = false
			detection_r.disabled = false
			detection_l.disabled = true

func _on_range_body_entered(body):
	if animated_sprite_2d.animation == "move":
		has_input_dmg = false
	attack()
	in_area = true
	
func _on_range_body_exited(body):
	in_area = false
	
func _hurt() -> void:
	wait = false

func _on_timer_timeout() -> void:
	wait = false
	if in_area:
		attack()
