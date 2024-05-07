extends CharacterBody2D

# initial variables for moving
const MAX_SPEED = 100
const ACCELERATION = 700
const FRICTION = 1400

enum{
	MOVING,
	DASHING,
	ATTACKING
}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D # importing the animation sprite
var last_dir: Vector2 = Vector2(0, 1) # Vector2 of the last direction faced for idling animations
var state = MOVING

func _ready():
	motion_mode = 1

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
		state = ATTACKING # changing the state to ATTACK

func attack_state(delta):
	if last_dir.x != 0: # if the player was moving towards left or right
		animated_sprite_2d.play("atk_right_1") # playing the correct animation (same for the other if/elif)
		await animated_sprite_2d.animation_finished # waiting for the animation to finish (same for the other if/elif)
	elif last_dir.y < 0: # if the player was moving towards bottom
		animated_sprite_2d.play("atk_up_1")
		await animated_sprite_2d.animation_finished
	elif last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("atk_down_1")
		await animated_sprite_2d.animation_finished
		
	state = MOVING # changing the state to MOVING
