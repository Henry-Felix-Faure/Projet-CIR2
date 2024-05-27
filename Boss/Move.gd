extends State

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var atilla: CharacterBody2D = $"../.."
var player : CharacterBody2D
var move_y
var timer
func Enter():
	animated_sprite_2d.play("idle")
	player = atilla.get_parent().get_node("Bob")
	var rand = RandomNumberGenerator.new()
	move_y = rand.randf_range(-2, 2)
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 3.5
	timer.start()
	timer.timeout.connect(launch_atk)
	
func Exit():
	timer.queue_free()
	
func Update(delta:float):
	var p_x = player.position.x
	var p_y = player.position.y
	var x = 0
	if p_x > atilla.position.x:
		x = -1
		animated_sprite_2d.flip_h = true
	else:
		x = 1
		animated_sprite_2d.flip_h = false
	var mouvement = Vector2(x, move_y).normalized()
	atilla.velocity = mouvement * 75
	atilla.move_and_collide(atilla.velocity * delta)


func _on_detection_player_body_entered(_body: Node2D) -> void:
	if atilla.is_full_recovery : return
	if atilla.is_aoe_cd:
		if atilla.is_atk_cd:
			state_transition.emit(self, "Dash_Atk")
		else:
			if randf_range(0,1) > 0.75:
				state_transition.emit(self, "Atk")
			else: state_transition.emit(self, "Dash_Out")
	else:
		state_transition.emit(self, "Aoe")

func _on_detection_player_atk_body_exited(_body: Node2D) -> void:
	state_transition.emit(self, "Atk")

func launch_atk():
	if randf_range(0,1) > 0.75:
				state_transition.emit(self, "Atk")
	else:
		state_transition.emit(self, "Dash_Atk")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	state_transition.emit(self, "Dash_Atk")
