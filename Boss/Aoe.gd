extends State

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

func Enter():
	animated_sprite_2d.play("aoe")
	
func animation_finished():
	state_transition.emit(self, "Recovery_AOE")
