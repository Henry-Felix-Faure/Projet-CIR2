extends CharacterBody2D

# initial variables for moving
@export var MAX_SPEED: int = 100
var ACCELERATION: int = 10000
var FRICTION: int = 10000

@export var AIMING_MOUSE: bool

enum{
	MOVING,
	DASHING_INIT,
	DASHING_RECOVERY,
	ATTACKING
}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D # importing the animation sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer # importing the animation player
@onready var collision_shape_2d = $CollisionShape2D

var last_dir: Vector2 = Vector2(0, 1) # Vector2 of the last direction faced for animations
var animation_playing = false
var state = MOVING
var attack_select: int
var attacks_array: Array = [
	["atk_right_1", "atk_right_2", "atk_right_3"], 
	["atk_down_1", "atk_down_2", "atk_down_3"], 
	["atk_up_1", "atk_up_2", "atk_up_3"]
]
var cursor_pos_from_player: Vector2

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready():
	attack_select = 0

func next_animation_selector_moving(input_vector: Vector2): # function to decide which running animations we want to play
	if input_vector.x > 0: # if the player moving towards the right
		animated_sprite_2d.flip_h = false # facing right
		animated_sprite_2d.play("run_right") # playing the correct animation (same for the other if/elif)
		animation_player.play("run_right_tempo")
		last_dir = Vector2.ZERO # resetting the stored last direction faced (same for the other if/elif)
		last_dir.x = 1 # setting the last direction faced (same for the other if/elif)
	elif input_vector.x < 0: # elif the player moving towards the left
		animated_sprite_2d.flip_h = true # facing left
		animated_sprite_2d.play("run_right")
		animation_player.play("run_left_tempo")
		last_dir = Vector2.ZERO
		last_dir.x = -1	
	elif input_vector.y > 0: # elif the player moving towards the bottom
		animated_sprite_2d.play("run_down")
		animation_player.play("run_down_tempo")
		last_dir = Vector2.ZERO
		last_dir.y = 1
	elif input_vector.y < 0: # elif the player moving towards the top
		animated_sprite_2d.play("run_up")
		animation_player.play("run_up_tempo")
		last_dir = Vector2.ZERO
		last_dir.y = -1
		
func next_animation_selector_idling(): # function to decide which idling animations we want to play
	if last_dir.x != 0: # if the player was moving towards left or right
		animated_sprite_2d.play("idle_right") # playing the correct animation (same for the other if/elif)
		if last_dir.x > 0: # if the player was moving towards right
			animation_player.play("idle_right_tempo")
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
	match state: # switch case to call the function associated to the action
		MOVING:
			move_state(delta)
		DASHING_INIT:
			dash_init_state(delta)
		DASHING_RECOVERY:
			dash_recovery_state(delta)
		ATTACKING:
			attack_state(delta)

func move_state(delta):
	MAX_SPEED = 100
	
	var input_vector = Vector2.ZERO # resetting the input vector
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") # setting the direction for next move by checking which key is pressed (left or right, or both (not moving))
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") # setting the direction for next move by checking which key is pressed (top or bottom, or both (not moving))
	input_vector = input_vector.normalized() # we need to normalize because if we move diagonally we will move sqrt(2) pixel instead of 1 pixel
	
	if input_vector != Vector2.ZERO: # if we detect a move to execute
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
		next_animation_selector_moving(input_vector) # calling the function to select the right running animations
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # updating velocity while taking the parameters in consideration (FRICTION)
		next_animation_selector_idling() # calling the function to select the right idling animations
	
	move_and_slide() # moving the character based on the velocity
	
	if Input.is_action_just_pressed("ui_attack"): # if left click is pressed
		attack_select = 1
		cursor_pos_from_player.x = get_global_mouse_position().x - position.x
		cursor_pos_from_player.y = get_global_mouse_position().y - position.y
		state = ATTACKING # changing the state to ATTACK
		
	if Input.is_action_just_pressed("ui_dash"): # if left click is pressed
		state = DASHING_INIT # changing the state to DASH

func next_animation_selector_attacking():
	if not AIMING_MOUSE:
		if last_dir.x != 0: # if the player was moving towards left or right
			animated_sprite_2d.play(attacks_array[0][attack_select-1]) # playing the correct animation of attack (same for the other if/elif)
			match attack_select: # switch case to play the right tempo for attack
				1:
					if last_dir.x > 0:
						animation_player.play("atk_right_1_tempo")
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
			animated_sprite_2d.play(attacks_array[1][attack_select-1])
			match attack_select: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_down_1_tempo")
				2:
					animation_player.play("atk_down_2_tempo")
				3:
					animation_player.play("atk_down_3_tempo")

			
		elif last_dir.y < 0: # if the player was moving towards top
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(attacks_array[2][attack_select-1])
			match attack_select: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_up_1_tempo")
				2:
					animation_player.play("atk_up_2_tempo")
				3:
					animation_player.play("atk_up_3_tempo")		
	else:
		if cursor_pos_from_player.x > 0 and abs(cursor_pos_from_player.x) >= abs(cursor_pos_from_player.y): # if the player was aiming towards right
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(attacks_array[0][attack_select-1]) # playing the correct animation of attack (same for the other if/elif)
			match attack_select: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_right_1_tempo")
				2:
					animation_player.play("atk_right_2_tempo")
				3:
					animation_player.play("atk_right_3_tempo")
						
		elif cursor_pos_from_player.x < 0 and abs(cursor_pos_from_player.x) > abs(cursor_pos_from_player.y): # if the player was aiming towards left
			animated_sprite_2d.flip_h = true # facing right
			animated_sprite_2d.play(attacks_array[0][attack_select-1]) # playing the correct animation of attack (same for the other if/elif)
			match attack_select: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_left_1_tempo")
				2:
					animation_player.play("atk_left_2_tempo")
				3:
					animation_player.play("atk_left_3_tempo")
		
		elif cursor_pos_from_player.y > 0 and abs(cursor_pos_from_player.y) >= abs(cursor_pos_from_player.x): # if the player was aiming towards bottom
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(attacks_array[1][attack_select-1])
			match attack_select: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_down_1_tempo")
				2:
					animation_player.play("atk_down_2_tempo")
				3:
					animation_player.play("atk_down_3_tempo")

			
		elif cursor_pos_from_player.y < 0 and abs(cursor_pos_from_player.y) > abs(cursor_pos_from_player.x): # if the player was moving towards top
			animated_sprite_2d.flip_h = false # facing right
			animated_sprite_2d.play(attacks_array[2][attack_select-1])
			match attack_select: # switch case to play the right tempo for attack
				1:
					animation_player.play("atk_up_1_tempo")
				2:
					animation_player.play("atk_up_2_tempo")
				3:
					animation_player.play("atk_up_3_tempo")		

func attack_state(delta): # function who is handling the different case of attack
	next_animation_selector_attacking() # call the function to play the right animation
	
	if Input.is_action_just_pressed("ui_attack") and attack_select < 3: # if left click is pressed
		attack_select += 1
		cursor_pos_from_player.x = get_global_mouse_position().x - position.x
		cursor_pos_from_player.y = get_global_mouse_position().y - position.y
	
	var input_vector = Vector2.ZERO # resetting the input vector
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") # setting the direction for next move by checking which key is pressed (left or right, or both (not moving))
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") # setting the direction for next move by checking which key is pressed (top or bottom, or both (not moving))
	input_vector = input_vector.normalized() # we need to normalize because if we move diagonally we will move sqrt(2) pixel instead of 1 pixel
	
	if input_vector != Vector2.ZERO: # if we detect a move to execute
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # updating velocity while taking the parameters in consideration (FRICTION)
	
	move_and_slide() # moving the character based on the velocity
	
	await animated_sprite_2d.animation_finished # waiting for the animation to finish 

	attack_select = 0
	state = MOVING # changing the state to MOVING

func next_animation_selector_dashing_init():
	if last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.play("dash_right_init") # playing the correct animation (same for the other if/elif)
		animated_sprite_2d.flip_h = false # facing right
	elif last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.play("dash_right_init")
		animated_sprite_2d.flip_h = true # facing left		
	elif last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("dash_right_init")
	elif last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("dash_right_init")

func dash_init_state(delta):
	var input_vector = Vector2.ZERO # resetting the input vector
	
	if last_dir.x > 0: # if the player was moving towards right
		input_vector.x = 1
	elif last_dir.x < 0: # if the player was moving towards left
		input_vector.x = -1
	elif last_dir.y > 0: # if the player was moving towards bottom
		input_vector.y = 1
	elif last_dir.y < 0: # if the player was moving towards top
		input_vector.y = -1
		
	collision_shape_2d.disabled = true
	next_animation_selector_dashing_init()		
	
	MAX_SPEED = 300
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
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
	
	state = DASHING_RECOVERY
	
func next_animation_selector_dashing_recovery():
	if last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.play("dash_right_recovery") # playing the correct animation (same for the other if/elif)
		animated_sprite_2d.flip_h = false # facing right
		animation_player.play("dash_right_recovery_tempo")
	elif last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.play("dash_right_recovery")
		animated_sprite_2d.flip_h = true # facing left		
		animation_player.play("dash_left_recovery_tempo")
	elif last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("dash_right_recovery")
		animation_player.play("dash_right_recovery_tempo")
	elif last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("dash_right_recovery")
		animation_player.play("dash_right_recovery_tempo")

func dash_recovery_state(delta):
	var input_vector = Vector2.ZERO # resetting the input vector
	
	if last_dir.x > 0: # if the player was moving towards right
		input_vector.x = 1
	elif last_dir.x < 0: # if the player was moving towards left
		input_vector.x = -1
	elif last_dir.y > 0: # if the player was moving towards bottom
		input_vector.y = 1
	elif last_dir.y < 0: # if the player was moving towards top
		input_vector.y = -1
		
	next_animation_selector_dashing_recovery() # calling the function to select the right dashing animations
	
	MAX_SPEED = 100
	
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) # updating velocity while taking the parameters in consideration (MAX_SPEED, ACCELERATION)
	move_and_slide() # moving the character based on the velocity
	
	await animated_sprite_2d.animation_finished # waiting for the animation to finish
	
	state = MOVING

func _on_sword_area_2d_body_entered(body):
	if body.is_in_group("Damageable"):
		print("ish")
