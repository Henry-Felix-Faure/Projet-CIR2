extends AnimatedSprite2D

@onready var detect_action_player: Area2D = $DetectActionPlayer
@onready var player = get_node("../Bob")
@onready var ennemies_stats_component: EnnemiesStatsComponent = $EnnemiesStatsComponent
@onready var timer: Timer = $Timer
@onready var sprite = $"."
@onready var flashTimer = $FlashTimer

var found : bool = false

func _ready() -> void:
	detect_action_player.body_entered.connect(player_detected)
	detect_action_player.body_exited.connect(player_exited)
	
func _process(delta):
	if(!found):
		position = position.move_toward(player.position, delta*ennemies_stats_component.SPEED)

func player_detected(body : Node2D):
	found = true
	while(found):
		var time : float = 3 - (ennemies_stats_component.ATK_SPEED * pow(10, -1))
		timer.wait_time = time
		print_debug(timer.wait_time)
		detect_action_player.call_function_with_player(body)
		timer.start()
		await timer.timeout
	
func player_exited(body : Node2D):
	await timer.timeout
	found = false

func flash():
	sprite.material.set_shader_parameter("flash_modifier",1)
	flashTimer.start()

func _on_flash_timer_timeout():
		sprite.material.set_shader_parameter("flash_modifier",0)

func _on_hurt_component_hurted():
	print("aa")
