extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func Enter():
	bob.parrying = true
	if bob.cancel_dash_parry:
		bob.hurtbox_area_2d.is_invincible = false # disabling the hurtbox of the player
		bob.collision_shape_2d.disabled = false # disabling the hitbox of the player
	bob.cancel_dash_parry = false
	next_animation_selector_parrying()
	
func Exit():
	bob.parrying = false
	
func Update(_delta:float):
	pass

func animation_finished():
	state_transition.emit(self, "PARRYING_RECOVERY")

func next_animation_selector_parrying():
	if bob.last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.flip_h = false # facing right
		match bob.parry_lvl:
			1:
				animated_sprite_2d.play("parry_right_1") # playing the correct animation (same for the other if/elif)
			2:
				animated_sprite_2d.play("parry_right_2")
			3:
				animated_sprite_2d.play("parry_right_3")
		animation_player.play("parry_right_tempo")
	elif bob.last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.flip_h = true # facing right
		match bob.parry_lvl:
			1:
				animated_sprite_2d.play("parry_right_1") # playing the correct animation (same for the other if/elif)
			2:
				animated_sprite_2d.play("parry_right_2")
			3:
				animated_sprite_2d.play("parry_right_3")
		animation_player.play("parry_right_tempo")
	elif bob.last_dir.y > 0: # if the player was moving towards bottom
		match bob.parry_lvl:
			1:
				animated_sprite_2d.play("parry_down_1") # playing the correct animation (same for the other if/elif)
			2:
				animated_sprite_2d.play("parry_down_2")
			3:
				animated_sprite_2d.play("parry_down_3")
		animation_player.play("parry_down_tempo")
	elif bob.last_dir.y < 0: # if the player was moving towards top
		match bob.parry_lvl:
			1:
				animated_sprite_2d.play("parry_up_1") # playing the correct animation (same for the other if/elif)
			2:
				animated_sprite_2d.play("parry_up_2")
			3:
				animated_sprite_2d.play("parry_up_3")
		animation_player.play("parry_up_tempo")
