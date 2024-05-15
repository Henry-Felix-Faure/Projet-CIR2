extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func Enter():
	next_animation_selector_attacking() # call the function to play the right animation
	
func Exit():
	pass
	
func Update(_delta:float):	
	if Input.is_action_just_pressed("ui_attack") and bob.attack_left != 0: # if left click is pressed and we still have attack left
		bob.attack_left -= 1 # updating the attack_left variable 
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
		
	# this code from move_state() is here because we need to be able to move while certain part of the attack animation
	bob.input_vector = Vector2.ZERO # resetting the input vector
	bob.input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") # setting the direction for next move by checking which key is pressed (left or right, or both (not moving))
	bob.input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") # setting the direction for next move by checking which key is pressed (top or bottom, or both (not moving))
	bob.input_vector = bob.input_vector.normalized() # we need to normalize the vector because if we move diagonally we will move sqrt(2) pixel instead of 1 pixel
	
	#if bob.input_vector != Vector2.ZERO: # if we detect an input
		#bob.velocity = bob.input_vector * bob.BASE_SPEED
	#else: # not moving
		#bob.velocity = Vector2.ZERO
		
	bob.velocity = bob.last_dir_attack_array[1] * bob.BASE_SPEED
	
	bob.move_and_collide(bob.velocity * _delta) # moving the character based on the velocity


func animation_finished():
	if bob.attack_left == 0: # if we just performed the first attack and we still have one or two more to do
		state_transition.emit(self, "ATK_3")
	else: # no attack to perform next
		if bob.AIMING_MOUSE:
			bob.cursor_pos_attack_array = []
		else:
			bob.last_dir_attack_array = []
		bob.attack_left = 3 # resetting the atdtack_left variable
		state_transition.emit(self, "MOVING")
	

func next_animation_selector_attacking():
	var is_crit: bool = get_parent().is_attack_crit()
	if not bob.AIMING_MOUSE:
		if bob.last_dir_attack_array[1].x != 0: # if the player was moving towards left or right
			animated_sprite_2d.play(bob.attacks_array[0][1]) # playing the correct animation of attack (same for the other if/elif)
			if bob.last_dir_attack_array[1].x > 0:
				animated_sprite_2d.flip_h = false # facing right
				animation_player.play("atk_right_2_tempo") # playing the correct animation tempo for hitbox (player and sword) (same for the other if/elif)
			elif bob.last_dir_attack_array[1].x < 0:
				animated_sprite_2d.flip_h = true # facing right
				animation_player.play("atk_left_2_tempo")
		
		elif bob.last_dir_attack_array[1].y > 0: # if the player was moving towards bottom
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(bob.attacks_array[1][1])
			animation_player.play("atk_down_2_tempo")
		
		elif bob.last_dir_attack_array[1].y < 0: # if the player was moving towards top
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(bob.attacks_array[2][1])
			animation_player.play("atk_up_2_tempo")
	else:
		var cursor_pos_used: Vector2 = bob.cursor_pos_attack_array[1]		
		if cursor_pos_used.x > 0 and abs(cursor_pos_used.x) >= abs(cursor_pos_used.y): # if the player was aiming towards right
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(bob.attacks_array[0][1]) # playing the correct animation of attack (same for the other if/elif)
			animation_player.play("atk_right_2_tempo")
						
		elif cursor_pos_used.x < 0 and abs(cursor_pos_used.x) > abs(cursor_pos_used.y): # if the player was aiming towards left
			animated_sprite_2d.flip_h = true # facing right
			animated_sprite_2d.play(bob.attacks_array[0][1]) # playing the correct animation of attack (same for the other if/elif)
			animation_player.play("atk_left_2_tempo")
		
		elif cursor_pos_used.y > 0 and abs(cursor_pos_used.y) >= abs(cursor_pos_used.x): # if the player was aiming towards bottom
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(bob.attacks_array[1][1])
			animation_player.play("atk_down_2_tempo")
	
		elif cursor_pos_used.y < 0 and abs(cursor_pos_used.y) > abs(cursor_pos_used.x): # if the player was moving towards top
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(bob.attacks_array[2][1])
			animation_player.play("atk_up_2_tempo")

