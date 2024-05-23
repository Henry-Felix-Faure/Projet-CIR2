extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var audio_draw_sword: AudioStreamPlayer2D = $"../../audio_draw_sword"
@onready var stats_component = $"../../StatsComponent"

func Enter():
	bob.parrying = true
	if bob.cancel_dash_parry:
		bob.hurtbox_area_2d.is_invincible = false # disabling the hurtbox of the player
		bob.collision_shape_2d.disabled = false # disabling the hitbox of the player
	bob.cancel_dash_parry = false
	audio_draw_sword.play()
	next_animation_selector_parrying()
	
func Exit():
	bob.parrying = false
	bob.explosion_particles.emitting = false
	
func Update(_delta:float):
	pass

func animation_finished():
	state_transition.emit(self, "PARRYING_RECOVERY")

func next_animation_selector_parrying():
	var parry_lvl: int = bob.parry_lvl
	if bob.last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.flip_h = false # facing right
		match parry_lvl:
			1:
				animated_sprite_2d.play("parry_right_1") # playing the correct animation (same for the other if/elif)
			2:
				animated_sprite_2d.play("parry_right_2")
			3:
				animated_sprite_2d.play("parry_right_3")
		animation_player.play("parry_right_tempo")
	elif bob.last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.flip_h = true # facing right
		match parry_lvl:
			1:
				animated_sprite_2d.play("parry_right_1") # playing the correct animation (same for the other if/elif)
			2:
				animated_sprite_2d.play("parry_right_2")
			3:
				animated_sprite_2d.play("parry_right_3")
		animation_player.play("parry_left_tempo")
	elif bob.last_dir.y > 0: # if the player was moving towards bottom
		match parry_lvl:
			1:
				animated_sprite_2d.play("parry_down_1") # playing the correct animation (same for the other if/elif)
			2:
				animated_sprite_2d.play("parry_down_2")
			3:
				animated_sprite_2d.play("parry_down_3")
		animation_player.play("parry_down_tempo")
	elif bob.last_dir.y < 0: # if the player was moving towards top
		match parry_lvl:
			1:
				animated_sprite_2d.play("parry_up_1") # playing the correct animation (same for the other if/elif)
			2:
				animated_sprite_2d.play("parry_up_2")
			3:
				animated_sprite_2d.play("parry_up_3")
		animation_player.play("parry_up_tempo")
