extends CharacterBody2D

@export var stats: EnnemiesStatsComponent

var speed: float = 100.0

const expScene = preload("res://experience/experience.tscn")

@onready var tik_tak: AudioStreamPlayer2D = $"tik tak"
@onready var explosion_sound: AudioStreamPlayer2D = $explosion_sound

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var range: Area2D = $range
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_node("/root/World/Bob")
@onready var timer_cooldown: Timer = $Timer2
@onready var attack_explo: CollisionShape2D = $HitboxComponent/attack_explo



var explosion : bool = false
var in_area : bool = false
var explose_now : bool = false


func _ready():
	attack_explo.set_deferred("disabled", true)
	range.body_entered.connect(_on_range_body_entered)
	range.body_exited.connect(_on_range_body_exited)


func cooldown() -> void:
	if (!explosion):
		tik_tak.play()
		animated_sprite_2d.play("cooldown")
		timer_cooldown.start()
		speed = 85.0
		explosion = true
	
	
func explose() -> void:
	if (!explose_now):
		attack_explo.set_deferred("disabled", false)
		speed = 0.0
		collision_shape_2d.disabled = true
		explose_now = true
		explosion_sound.play()
		animated_sprite_2d.play("explosion")
		await animated_sprite_2d.animation_finished
		if in_area:
			#degat joueur
			pass
		queue_free()


func _physics_process(delta):
	if(!explosion):
		animated_sprite_2d.play("move")
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed * delta 
		move_and_collide(velocity)
	
		if direction.x > 0:
			animated_sprite_2d.flip_h = true
			
		else:
			animated_sprite_2d.flip_h = false
	elif explosion :
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed * delta 
		move_and_collide(velocity)
	
		if direction.x > 0:
			animated_sprite_2d.flip_h = true
			
		else:
			animated_sprite_2d.flip_h = false

func _on_range_body_entered(body):
	cooldown()
	in_area = true

func _on_range_body_exited(body):
	in_area = false


func _on_timer_2_timeout() -> void:
	explose()
