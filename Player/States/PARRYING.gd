extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func Enter():
	if bob.cancel_dash_parry:
		bob.hurtbox_area_2d.is_invincible = false # disabling the hurtbox of the player
		bob.collision_shape_2d.disabled = false # disabling the hitbox of the player
	bob.cancel_dash_parry = false
	next_animation_selector_parrying()
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func animation_finished():
	state_transition.emit(self, "PARRYING_RECOVERY")

func next_animation_selector_parrying():
	if bob.last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.play("parry_right") # playing the correct animation (same for the other if/elif)
		animated_sprite_2d.flip_h = false # facing right
		animation_player.play("parry_right_tempo")
	elif bob.last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.play("parry_right")
		animated_sprite_2d.flip_h = true # facing left
		animation_player.play("parry_right_tempo")
	elif bob.last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("parry_down")
		animation_player.play("parry_down_tempo")
	elif bob.last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("parry_up")
		animation_player.play("parry_up_tempo")
