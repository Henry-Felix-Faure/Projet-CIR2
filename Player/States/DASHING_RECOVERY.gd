extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var MaLigne = $"../../Line2D"

func Enter():
	bob.BASE_SPEED = 100
	next_animation_selector_dashing_recovery() # calling the function to select the right dashing recovery animations
	
func Exit():
	MaLigne.start_fade_out()
	pass
	
func Update(_delta:float):
	bob.velocity = bob.last_input_vector * bob.BASE_SPEED # updating velocity while taking the parameters in consideration (MAX_SPEED)
	bob.move_and_collide(bob.velocity * _delta) # moving the character based on the velocity
	
	
func animation_finished():
	bob.hurtbox_area_2d.is_invincible = false # we re-enable the hurtbox of the player
	bob.collision_shape_2d.disabled = false # we re-enable the hitbox of the player
	state_transition.emit(self, "MOVING")

func next_animation_selector_dashing_recovery():
	if bob.last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.play("dash_right_recovery") # playing the correct animation (same for the other if/elif)
		animated_sprite_2d.flip_h = false # facing right
	elif bob.last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.play("dash_right_recovery")
		animated_sprite_2d.flip_h = true # facing left		
	elif bob.last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("dash_down_recovery")
		animated_sprite_2d.flip_h = false # facing right
	elif bob.last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("dash_up_recovery")
		animated_sprite_2d.flip_h = false # facing right
