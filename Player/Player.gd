extends CharacterBody2D

# importing initial variable linked to the CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_area_2d: HurtboxComponent = $HurtboxArea2D
@export var stats_component: StatsComponent

# initial variables for moving and animations
@export var MAX_SPEED: int = 100
var ACCELERATION: int = 10000
var FRICTION: int = 10000
var input_vector: Vector2 = Vector2.ZERO # Vector2 of the current input
var last_input_vector: Vector2 = Vector2.ZERO # Vector2 of the last input
var last_dir: Vector2 = Vector2(0, 1) # Vector2 of the last direction faced for animations
var attack_left: int = 3 # number of attack that you can still perform (currently the combo is 3)
var attacks_array: Array = [
	["atk_right_1", "atk_right_2", "atk_right_3"], 
	["atk_down_1", "atk_down_2", "atk_down_3"], 
	["atk_up_1", "atk_up_2", "atk_up_3"]
] # array of array for each 3 attacks of each 4 four directions (left and right are the same)

# aiming with mouse
@export var AIMING_MOUSE: bool # boolean variable to enable / disable aiming for attack with mouse instead of keyboard
var cursor_pos_from_player: Vector2 # Vector2 to store the difference between cursor position and player position 

# State machine
var state = MOVING # variable for the current state of the player
# enum of different state for the player 
enum{ 
	MOVING,
	DASHING_INIT,
	DASHING_RECOVERY,
	ATK_1,
	ATK_2,
	ATK_3,
	DYING
}

func wait(seconds: float) -> void: # custom wait function
	await get_tree().create_timer(seconds).timeout

func _ready():
	pass

func next_animation_selector_moving(): # function to decide which running animations we want to play
	if input_vector.x > 0: # if the player was moving towards the right
		animated_sprite_2d.flip_h = false # facing right
		animated_sprite_2d.play("run_right") # playing the correct animation (same for the other if/elif)
		animation_player.play("run_right_tempo") # playing the correct animation tempo for hitbox (same for the other if/elif)
		last_dir = Vector2.ZERO # resetting the stored last direction faced (same for the other if/elif)
		last_dir.x = 1 # setting the last direction faced (same for the other if/elif)
	elif input_vector.x < 0: # elif the player was moving towards the left
		animated_sprite_2d.flip_h = true # facing left
		animated_sprite_2d.play("run_right")
		animation_player.play("run_left_tempo")
		last_dir = Vector2.ZERO
		last_dir.x = -1	
	elif input_vector.y > 0: # elif the player was moving towards the bottom
		animated_sprite_2d.play("run_down")
		animation_player.play("run_down_tempo")
		last_dir = Vector2.ZERO
		last_dir.y = 1
	elif input_vector.y < 0: # elif the player was moving towards the top
		animated_sprite_2d.play("run_up")
		animation_player.play("run_up_tempo")
		last_dir = Vector2.ZERO
		last_dir.y = -1
		
func next_animation_selector_idling(): # function to decide which idling animations we want to play
	if last_dir.x != 0: # if the player was moving towards left or right
		animated_sprite_2d.play("idle_right") # playing the correct animation (same for the other if/elif)
		if last_dir.x > 0: # if the player was moving towards right
			animation_player.play("idle_right_tempo") # playing the correct animation tempo for hitbox (same for the other if/elif)
			animated_sprite_2d.flip_h = false # facing right
		elif last_dir.x < 0: # if the player was moving towards left
			animation_player.play("idle_left_tempo")
			animated_sprite_2d.flip_h = true # facing left		
	elif last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("idle_down")
		animated_sprite_2d.flip_h = false # facing right
		animation_player.play("idle_down_tempo")
	elif last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("idle_up")
		animated_sprite_2d.flip_h = false # facing right
		animation_player.play("idle_up_tempo")

func _physics_process(delta): 
	match state: # switch case to call the function associated to the current state of the player
		MOVING:
			move_state(delta)
		DASHING_INIT:
			dash_init_state(delta)
		DASHING_RECOVERY:
			dash_recovery_state(delta)
		ATK_1:
			attack(delta, 1)
		ATK_2:
			attack(delta, 2)
		ATK_3:
			attack(delta, 3)
		DYING:
			death_state()

func move_state(delta):
	MAX_SPEED = 100  # resetting MAX_SPEED
	input_vector = Vector2.ZERO # resetting the input vector
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") # setting the direction for the next move by checking which key is pressed (left or right, or both (not moving))
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") # setting the direction for the next move by checking which key is pressed (top or bottom, or both (not moving))
	input_vector = input_vector.normalized() # we need to normalize the vector because if we move diagonally we will move sqrt(2) pixel instead of 1 pixel
	
	if input_vector != Vector2.ZERO: # if we detect an input
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
		next_animation_selector_moving() # calling the function to select the right running animations
	else: # not moving
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # updating velocity while taking the parameters in consideration (FRICTION)
		next_animation_selector_idling() # calling the function to select the right idling animations
	
	move_and_slide() # moving the character based on the velocity
	
	if Input.is_action_just_pressed("ui_attack"): # if left click is pressed
		attack_left = 2 # we will perform 1 attack so we can still do 2 more
		if AIMING_MOUSE:
			cursor_pos_from_player.x = get_global_mouse_position().x - position.x # compute the difference between cursor position and player position 
			cursor_pos_from_player.y = get_global_mouse_position().y - position.y
		state = ATK_1 # changing the state to first attack ATK_1
		
		
	if Input.is_action_just_pressed("ui_dash"): # if space bar is pressed
		if input_vector == Vector2.ZERO: # if we were not moving, the last input will be the direction we are facing
			last_input_vector = last_dir
		else:
			last_input_vector = input_vector # if we were moving, the last input will be the current input
		state = DASHING_INIT # changing the state to DASHING_INIT
	
	if Input.is_action_just_pressed("ui_kill_debug"): # if F2 is pressed / debug tool
		stats_component.health = 0

func next_animation_selector_attacking(attack_number: int): # function to decide which attack animations we want to play
	if not AIMING_MOUSE:
		if last_dir.x != 0: # if the player was moving towards left or right
			animated_sprite_2d.play(attacks_array[0][attack_number-1]) # playing the correct animation of attack (same for the other if/elif)
			match attack_number: # switch case to play the right tempo for attack
				1:
					if last_dir.x > 0:
						animation_player.play("atk_right_1_tempo") # playing the correct animation tempo for hitbox (player and sword) (same for the other if/elif)
					elif last_dir.x < 0:
						animation_player.play("atk_left_1_tempo")
				2:
					if last_dir.x > 0:
						animation_player.play("atk_right_2_tempo")
					elif last_dir.x < 0:
						animation_player.play("atk_left_2_tempo")
				3:
					if last_dir.x > 0:
						animation_player.play("atk_right_3_tempo")
					elif last_dir.x < 0:
						animation_player.play("atk_left_3_tempo")
		
		elif last_dir.y > 0: # if the player was moving towards bottom
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(attacks_array[1][attack_number-1])
			match attack_number: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_down_1_tempo")
				2:
					animation_player.play("atk_down_2_tempo")
				3:
					animation_player.play("atk_down_3_tempo")

			
		elif last_dir.y < 0: # if the player was moving towards top
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(attacks_array[2][attack_number-1])
			match attack_number: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_up_1_tempo")
				2:
					animation_player.play("atk_up_2_tempo")
				3:
					animation_player.play("atk_up_3_tempo")		
	else:
		if cursor_pos_from_player.x > 0 and abs(cursor_pos_from_player.x) >= abs(cursor_pos_from_player.y): # if the player was aiming towards right
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(attacks_array[0][attack_number-1]) # playing the correct animation of attack (same for the other if/elif)
			match attack_number: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_right_1_tempo")
				2:
					animation_player.play("atk_right_2_tempo")
				3:
					animation_player.play("atk_right_3_tempo")
						
		elif cursor_pos_from_player.x < 0 and abs(cursor_pos_from_player.x) > abs(cursor_pos_from_player.y): # if the player was aiming towards left
			animated_sprite_2d.flip_h = true # facing right
			animated_sprite_2d.play(attacks_array[0][attack_number-1]) # playing the correct animation of attack (same for the other if/elif)
			match attack_number: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_left_1_tempo")
				2:
					animation_player.play("atk_left_2_tempo")
				3:
					animation_player.play("atk_left_3_tempo")
		
		elif cursor_pos_from_player.y > 0 and abs(cursor_pos_from_player.y) >= abs(cursor_pos_from_player.x): # if the player was aiming towards bottom
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(attacks_array[1][attack_number-1])
			match attack_number: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_down_1_tempo")
				2:
					animation_player.play("atk_down_2_tempo")
				3:
					animation_player.play("atk_down_3_tempo")

			
		elif cursor_pos_from_player.y < 0 and abs(cursor_pos_from_player.y) > abs(cursor_pos_from_player.x): # if the player was moving towards top
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(attacks_array[2][attack_number-1])
			match attack_number: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_up_1_tempo")
				2:
					animation_player.play("atk_up_2_tempo")
				3:
					animation_player.play("atk_up_3_tempo")		

func attack(delta, attack_number: int): # function who is handling the case of attack
	next_animation_selector_attacking(attack_number) # call the function to play the right animation
	
	if Input.is_action_just_pressed("ui_attack") and attack_left != 0: # if left click is pressed and we still have attack left
		attack_left -= 1 # updating the attack_left variable 
	
	# this code from move_state() is here because we need to be able to move while certain part of the attack animation
	input_vector = Vector2.ZERO # resetting the input vector
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") # setting the direction for next move by checking which key is pressed (left or right, or both (not moving))
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") # setting the direction for next move by checking which key is pressed (top or bottom, or both (not moving))
	input_vector = input_vector.normalized() # we need to normalize the vector because if we move diagonally we will move sqrt(2) pixel instead of 1 pixel
	
	if input_vector != Vector2.ZERO: # if we detect a move to execute
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # updating velocity while taking the parameters in consideration (FRICTION)
	
	move_and_slide() # moving the character based on the velocity
	
	await animated_sprite_2d.animation_finished # waiting for the animation to finish 

	if (attack_number == 1 and attack_left <= 1): # if we just performed the first attack and we still have one or two more to do
		state = ATK_2 # changing the state variable to the second attack state
	elif (attack_number == 2 and attack_left == 0): # if we just performed the second attack and we have one more to do
		state = ATK_3 # changing the state variable to the third attack state
	else: # no attack to perform next
		attack_left = 3 # resetting the attack_left variable
		state = MOVING # state variable is set back to moving

func next_animation_selector_dashing_init():
	if last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.play("dash_right_init") # playing the correct animation (same for the other if/elif)
		animated_sprite_2d.flip_h = false # facing right
	elif last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.play("dash_right_init")
		animated_sprite_2d.flip_h = true # facing left		
	elif last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("dash_down_init")
	elif last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("dash_up_init")

func dash_init_state(delta):
	
	hurtbox_area_2d.is_invincible = true # disabling the hurtbox of the player
	collision_shape_2d.disabled = true # disabling the hitbox of the player
	next_animation_selector_dashing_init() # calling the function to select the right dashing init animations
	
	# the player is moving without any input towards the direction saved by the last_input_vector variable
	MAX_SPEED = 300 # setting the MAX_SPEED to 300 for the dash period
	velocity = velocity.move_toward(last_input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
	move_and_slide() # moving the character based on the velocity

	await animated_sprite_2d.animation_finished # waiting for the animation to finish
		
	#set_visible(false)
	#
	#MAX_SPEED = 300
	#velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
	#move_and_slide() # moving the character based on the velocity
	#
	#wait(0.3)
	#MAX_SPEED = 0
	#set_visible(true)
	
	state = DASHING_RECOVERY # state is set to DASHING_RECOVERY for the second part of the dash
	
func next_animation_selector_dashing_recovery():
	if last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.play("dash_right_recovery") # playing the correct animation (same for the other if/elif)
		animated_sprite_2d.flip_h = false # facing right
		#animation_player.play("dash_right_recovery_tempo")
	elif last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.play("dash_right_recovery")
		animated_sprite_2d.flip_h = true # facing left		
		#animation_player.play("dash_left_recovery_tempo")
	elif last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("dash_down_recovery")
		animated_sprite_2d.flip_h = false # facing right
		#animation_player.play("dash_right_recovery_tempo")
	elif last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("dash_up_recovery")
		animated_sprite_2d.flip_h = false # facing right
		#animation_player.play("dash_right_recovery_tempo")

func dash_recovery_state(delta):	
	next_animation_selector_dashing_recovery() # calling the function to select the right dashing recovery animations
	
	# the player is moving without any input towards the direction saved by the last_input_vector variable
	MAX_SPEED = 100 # resetting the MAX_SPEED value
	velocity = velocity.move_toward(last_input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
	move_and_slide() # moving the character based on the velocity
	
	await animated_sprite_2d.animation_finished # waiting for the animation to finish
	hurtbox_area_2d.is_invincible = false # we re-enable the hurtbox of the player
	collision_shape_2d.disabled = false # we re-enable the hitbox of the player
	
	state = MOVING  # state variable is set back to moving

func death_state(): # function that handle the death state
	hurtbox_area_2d.is_invincible = true # disabling the hurtbox of the player
	collision_shape_2d.disabled = true # disabling the hitbox of the player
	animated_sprite_2d.play("death") # playing the death animation
	await animated_sprite_2d.animation_finished # waiting for the animation to finish
	queue_free() # deleting the player from the scene

func _on_stats_component_no_health() -> void: # if the heatlh of the player drop to or below 0
	state = DYING # changing the state to DYING
