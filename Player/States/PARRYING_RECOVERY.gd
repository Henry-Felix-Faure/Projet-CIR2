extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func Enter():
	next_animation_selector_parrying_recovery()
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func animation_finished():
	state_transition.emit(self, "MOVING")

func next_animation_selector_parrying_recovery():
	if bob.last_dir.x > 0: # if the player was moving towards right
		animated_sprite_2d.play("parry_right_recovery") # playing the correct animation (same for the other if/elif)
		animated_sprite_2d.flip_h = false # facing right
		animation_player.play("parry_right_recovery_tempo")
	elif bob.last_dir.x < 0: # if the player was moving towards left
		animated_sprite_2d.play("parry_right_recovery")
		animated_sprite_2d.flip_h = true # facing left
		animation_player.play("parry_right_recovery_tempo")
	elif bob.last_dir.y > 0: # if the player was moving towards bottom
		animated_sprite_2d.play("parry_down_recovery")
		animation_player.play("parry_down_recovery_tempo")
	elif bob.last_dir.y < 0: # if the player was moving towards top
		animated_sprite_2d.play("parry_up_recovery")
		animation_player.play("parry_up_recovery_tempo")
