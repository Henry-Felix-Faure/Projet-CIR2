extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var camera_2d: Camera2D = $"../../Camera2D"
@onready var blood_particles: CPUParticles2D = $"../../BloodParticles"

#@onready var leapfrogger_map: Node2D = $"../../../Leapfrogger_map"
#@onready var pathfinding = leapfrogger_map.get_node("Pathfinding")
#@onready var path_line = leapfrogger_map.get_node("Line2D")

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta:float):
	#path_line.points = PackedVector2Array(pathfinding.astar_grid.get_point_path(bob.position/pathfinding.cell_size, Vector2i(0,0)))

	bob.input_vector = Vector2.ZERO # resetting the input vector
	bob.input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") # setting the direction for the next move by checking which key is pressed (left or right, or both (not moving))
	bob.input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") # setting the direction for the next move by checking which key is pressed (top or bottom, or both (not moving))
	bob.input_vector = bob.input_vector.normalized() # we need to normalize the vector because if we move diagonally we will move sqrt(2) pixel instead of 1 pixel
	
	if bob.input_vector != Vector2.ZERO: # if we detect an input
		bob.velocity = bob.input_vector * bob.BASE_SPEED
		#velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
		next_animation_selector_moving() # calling the function to select the right running animations
	else: # not moving
		bob.velocity = Vector2.ZERO
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # updating velocity while taking the parameters in consideration (FRICTION)
		next_animation_selector_idling() # calling the function to select the right idling animations
	
	bob.move_and_collide(bob.velocity * _delta) # moving the character based on the velocity
	
	if Input.is_action_just_pressed("ui_attack") and bob.atk_1_cd.is_stopped(): # if left click is pressed
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
			bob.atk_1_cd.start()
			state_transition.emit(self, "ATK_1")
		
	if Input.is_action_just_pressed("ui_dash") and bob.dash_timer.is_stopped(): # if space bar is pressed
		state_transition.emit(self, "DASHING_INIT")
	
	if Input.is_action_just_pressed("ui_parry") and bob.parry_timer.is_stopped(): # if right click is pressed
		state_transition.emit(self, "PARRYING")
	
	if Input.is_action_just_pressed("ui_kill_debug"): # if F2 is pressed / debug tool
		bob.stats_component.health = 0
		state_transition.emit(self, "DYING")
	
	if Input.is_action_just_pressed("ui_camera_debug"): # if ! is pressed / debug tool
		if camera_2d.zoom == Vector2(1,1):
			camera_2d.zoom = Vector2(0.12,0.12)
		else:
			camera_2d.zoom = Vector2(1,1)


func next_animation_selector_moving(): # function to decide which running animations we want to play
	if bob.input_vector.x > 0: # if the player was moving towards the right
		animated_sprite_2d.flip_h = false # facing right
		animated_sprite_2d.play("run_right") # playing the correct animation (same for the other if/elif)
		animation_player.play("run_right_tempo") # playing the correct animation tempo for hitbox (same for the other if/elif)
		bob.last_dir = Vector2.ZERO # resetting the stored last direction faced (same for the other if/elif)
		bob.last_dir.x = 1 # setting the last direction faced (same for the other if/elif)
	elif bob.input_vector.x < 0: # elif the player was moving towards the left
		animated_sprite_2d.flip_h = true # facing left
		animated_sprite_2d.play("run_right")
		animation_player.play("run_left_tempo")
		bob.last_dir = Vector2.ZERO
		bob.last_dir.x = -1	
	elif bob.input_vector.y > 0: # elif the player was moving towards the bottom
		animated_sprite_2d.play("run_down")
		animation_player.play("run_down_tempo")
		bob.last_dir = Vector2.ZERO
		bob.last_dir.y = 1
	elif bob.input_vector.y < 0: # elif the player was moving towards the top
		animated_sprite_2d.play("run_up")
		animation_player.play("run_up_tempo")
		bob.last_dir = Vector2.ZERO
		bob.last_dir.y = -1
		
func next_animation_selector_idling(): # function to decide which idling animations we want to play
	if bob.last_dir.x != 0: # if the player was moving towards left or right
		animated_sprite_2d.play("idle_right") # playing the correct animation (same for the other if/elif)
		if bob.last_dir.x > 0: # if the player was moving towards right
			animation_player.play("idle_right_tempo") # playing the correct animation tempo for hitbox (same for the other if/elif)
			animated_sprite_2d.flip_h = false # facing right
		elif bob.last_dir.x < 0: # if the player was moving towards left
			animation_player.play("idle_left_tempo")
			animated_sprite_2d.flip_h = true # facing left		
	elif bob.last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("idle_down")
		animated_sprite_2d.flip_h = false # facing right
		animation_player.play("idle_down_tempo")
	elif bob.last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("idle_up")
		animated_sprite_2d.flip_h = false # facing right
		animation_player.play("idle_up_tempo")
