extends CharacterBody2D

@onready var detect_action_player: Area2D = $"DetectActionPlayer"
@onready var player = get_node("../Bob")
@onready var ennemies_stats_component: EnnemiesStatsComponent = $"EnnemiesStatsComponent"
@onready var timer: Timer = $"Timer"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var found : bool = false

func _ready() -> void:
	animated_sprite_2d.play("move")
	detect_action_player.body_entered.connect(player_detected)
	detect_action_player.body_exited.connect(player_exited)
	
func _process(delta):
	if get_parent().get_node("Bob").position.x > position.x:
		animated_sprite_2d.flip_h = false
	else:
			animated_sprite_2d.flip_h = true
	if(!found):
		animated_sprite_2d.play("move")
		position = position.move_toward(player.position, delta*ennemies_stats_component.SPEED)

func player_detected(body: Node2D):
	found = true
	#animated_sprite_2d.play("detection")
	#await animated_sprite_2d.animation_finished
	while(found):
		animated_sprite_2d.play("atk_load")
		await animated_sprite_2d.animation_finished
		detect_action_player.call_function_with_player(body)
		var time : float = 3 - (ennemies_stats_component.ATK_SPEED * pow(10, -1))
		timer.wait_time = time
		timer.start()
		animated_sprite_2d.play("atk")
		await timer.timeout
	
func player_exited(_body : Node2D):
	await timer.timeout
	found = false
