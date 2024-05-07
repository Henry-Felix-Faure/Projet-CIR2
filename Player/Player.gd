extends CharacterBody2D

# initial variables for moving
@export var MAX_SPEED: int = 100
var ACCELERATION: int = 10000
var FRICTION: int = 10000

enum{
	MOVING,
	DASHING,
	ATTACKING
}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D # importing the animation sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer # importing the animation player

var last_dir: Vector2 = Vector2(0, 1) # Vector2 of the last direction faced for idling animations
var state = MOVING

var attacks_array: Array = [
	["atk_right_1", "atk_right_2", "atk_right_3"], 
	["atk_down_1", "atk_down_2", "atk_down_3"], 
	["atk_up_1", "atk_up_2", "atk_up_3"]
]

var attack_counter: int

func _ready():
	attack_counter = 0

func next_animation_selector_moving(input_vector: Vector2): # function to decide which running animations we want to play
	if input_vector.x > 0: # if the player moving towards the right
		animated_sprite_2d.flip_h = false # facing right
		animated_sprite_2d.play("run_right") # playing the correct animation (same for the other if/elif)
		last_dir = Vector2.ZERO # resetting the stored last direction faced (same for the other if/elif)
		last_dir.x = 1 # setting the last direction faced (same for the other if/elif)
	elif input_vector.x < 0: # elif the player moving towards the left
		animated_sprite_2d.flip_h = true # facing left
		animated_sprite_2d.play("run_right")
		last_dir = Vector2.ZERO
		last_dir.x = -1	
	elif input_vector.y > 0: # elif the player moving towards the bottom
		animated_sprite_2d.play("run_down")
		last_dir = Vector2.ZERO
		last_dir.y = 1
	elif input_vector.y < 0: # elif the player moving towards the top
		animated_sprite_2d.play("run_up")
		last_dir = Vector2.ZERO
		last_dir.y = -1
		
func next_animation_selector_idling(): # function to decide which idling animations we want to play
	if last_dir.x != 0: # if the player was moving towards left or right
		animated_sprite_2d.play("idle_right") # playing the correct animation (same for the other if/elif)
		if last_dir.x > 0: # if the player was moving towards right
			animated_sprite_2d.flip_h = false # facing right
		elif last_dir.x < 0: # if the player was moving towards left
			animated_sprite_2d.flip_h = true # facing left
		animated_sprite_2d.play("idle_right")
	elif last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("idle_down")
	elif last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("idle_up")
		
#func _input(event):
	#if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
	#elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)

func _physics_process(delta): 
	match state: # switch case to call the function associated to the action
		MOVING:
			move_state(delta)
		DASHING:
			pass
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
		attack_counter += 1
		state = ATTACKING # changing the state to ATTACK

func next_animation_selector_attacking():
	if last_dir.x != 0: # if the player was moving towards left or right
		animated_sprite_2d.play(attacks_array[0][attack_counter-1]) # playing the correct animation of attack (same for the other if/elif)
	elif last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play(attacks_array[1][attack_counter-1])
	elif last_dir.y < 0: # if the player was moving towards bottom
		animated_sprite_2d.play(attacks_array[2][attack_counter-1])
		
	match attack_counter: # switch case to play the right tempo for attack
		1:
			animation_player.play("atk_1_tempo")
		2:
			animation_player.play("atk_2_tempo")
		3:
			animation_player.play("atk_3_tempo")

func attack_state(delta): # function who is handling the different case of attack
	next_animation_selector_attacking() # call the function to play the right animation
	
	if Input.is_action_just_pressed("ui_attack") and attack_counter < 3: # if left click is pressed
		attack_counter += 1
	
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
	
	attack_counter = 0
	state = MOVING # changing the state to MOVING
