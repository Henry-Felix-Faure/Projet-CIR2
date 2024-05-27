extends State
@onready var full_recovery: Timer = $"../../FullRecovery"
@onready var dash_out_timer: Timer = $"../../DashOutTimer"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var atilla: CharacterBody2D = $"../.."
var player : CharacterBody2D
func Enter():
	player = atilla.get_parent().get_node("Bob")
	animated_sprite_2d.play("dash_right")
	dash_out_timer.start()
	var p_x = player.position.x
	if p_x > atilla.position.x:
		animated_sprite_2d.flip_h = false
	else :
		animated_sprite_2d.flip_h = true

func Exit():
	full_recovery.start()
	atilla.is_full_recovery = true

func Update(delta):
	var direction = -atilla.global_position.direction_to(player.global_position)
	atilla.velocity = direction * 300 * delta 
	atilla.move_and_collide(atilla.velocity)


func _on_dash_out_timer_timeout() -> void:
	state_transition.emit(self,"Move")
