extends CharacterBody2D

const SPEED: float = 1000.0

const expScene = preload("res://experience/experience.tscn")
const EnnemiesStatsComponent = preload("res://Scripts/Components/ennemies_stats_component.gd")
var ennemies_stats_component := EnnemiesStatsComponent.new()


@onready var range: Area2D = $range
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_node("/root/World/Player")
@onready var wait_timer: Timer = $Timer
var wait : bool = false
var in_area : bool = false


func _ready():
	var attackInterval = ennemies_stats_component.ATK_SPEED / 100
	wait_timer.wait_time = attackInterval
	range.body_entered.connect(_on_range_body_entered)
	range.body_exited.connect(_on_range_body_exited)


func attack() -> void:
	#damage le joueur
	animated_sprite_2d.play("attack")
	wait_timer.start()
	wait = true


func _physics_process(delta):
	if !wait:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED * delta
		move_and_slide()
		var temp_pos = direction.x

		if direction.x < 0:
			animated_sprite_2d.set_flip_h(true)
		else:
			animated_sprite_2d.set_flip_h(false)
		
		
		animated_sprite_2d.play("move")




func _on_range_body_entered(body):
	attack()
	in_area = true
	
func _on_range_body_exited(body):
	in_area = false

func _on_timer_timeout() -> void:
	wait = false
	if in_area:
		attack()
