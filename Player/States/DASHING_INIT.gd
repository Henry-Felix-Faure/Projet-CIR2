extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func Enter():
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
		state_transition.emit(self, "ATK_1")
		bob.cancel_dash = true

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
	if bob.cancel_dash:
		state_transition.emit(self,"ATK_1")
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