extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var MaLigne = $"../../Line2D"
@onready var audio_dash: AudioStreamPlayer2D = $"../../audio_dash"


func Enter():
	MaLigne.show()
	audio_dash.play()
	if bob.input_vector == Vector2.ZERO: # if we were not moving, the last input will be the direction we are facing
		bob.last_input_vector = bob.last_dir
	else:
		bob.last_input_vector = bob.input_vector # if we were moving, the last input will be the current input
	
	bob.hurtbox_area_2d.is_invincible = true # disabling the hurtbox of the player
	bob.collision_shape_2d.disabled = true # disabling the hitbox of the player
	next_animation_selector_dashing_init() # calling the function to select the right dashing init animations
	
func Exit():
	pass
	
func Update(_delta:float):
	bob.velocity = bob.last_input_vector * bob.DASH_SPEED # updating velocity while taking the parameters in consideration (MAX_SPEED)
	
	bob.move_and_collide(bob.velocity * _delta) # moving the character based on the velocity

	if Input.is_action_just_pressed("ui_attack"): # if left click is pressed
		if bob.AIMING_MOUSE:
			bob.cursor_pos_from_player.x = bob.get_global_mouse_position().x - bob.position.x # compute the difference between cursor position and player position 
			bob.cursor_pos_from_player.y = bob.get_global_mouse_position().y - bob.position.y
			bob.cursor_pos_attack_array.append(bob.cursor_pos_from_player)
		else:
			if bob.input_vector != Vector2.ZERO:
				if bob.input_vector.x > 0:
					bob.last_dir_attack_array.append(Vector2(1, 0))
				elif bob.input_vector.x < 0:
					bob.last_dir_attack_array.append(Vector2(-1, 0))
				elif bob.input_vector.y > 0:
					bob.last_dir_attack_array.append(Vector2(0, 1))
				elif bob.input_vector.y < 0:
					bob.last_dir_attack_array.append(Vector2(0, -1))
			else:
				bob.last_dir_attack_array.append(Vector2(bob.last_dir.x, bob.last_dir.y))
		bob.cancel_dash_attack = true
	
	if Input.is_action_just_pressed("ui_parry"): # if F2 is pressed / debug tool
		bob.cancel_dash_parry = true

	#set_visible(false)
	#
	#MAX_SPEED = 300
	#velocity = last_input_vector * MAX_SPEED # updating velocity while taking the parameters in consideration (MAX_SPEED)
	#move_and_collide(velocity * delta) # moving the character based on the velocity
	#
	#wait(0.3)
	#MAX_SPEED = 0
	#set_visible(true)
	

func animation_finished():
	if bob.cancel_dash_attack:
		state_transition.emit(self,"ATK_1")
	elif bob.cancel_dash_parry:
		state_transition.emit(self, "PARRYING")
	else:
		state_transition.emit(self,"DASHING_RECOVERY")


func next_animation_selector_dashing_init():
	if bob.last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.play("dash_right_init") # playing the correct animation (same for the other if/elif)
		animated_sprite_2d.flip_h = false # facing right
	elif bob.last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.play("dash_right_init")
		animated_sprite_2d.flip_h = true # facing left		
	elif bob.last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("dash_down_init")
	elif bob.last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("dash_up_init")
