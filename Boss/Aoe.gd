extends State

@onready var atilla: CharacterBody2D = $"../.."

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var collision_shape_2d: CollisionShape2D = $"../../Hitboxes/HitboxAoe/CollisionShape2D"
@onready var attack_aoe: AudioStreamPlayer2D = $"../../attack_aoe"

func Enter():
	animated_sprite_2d.play("aoe")
	animated_sprite_2d.flip_h = false
	
func Exit():
	atilla.is_aoe_cd = true
	atilla.aoe_cd.start()
	
func Update(_delta):
	if animated_sprite_2d.frame == 8:
		attack_aoe.play()
		collision_shape_2d.disabled = false
	if animated_sprite_2d.frame == 10:
		collision_shape_2d.disabled = true

func animation_finished():
	state_transition.emit(self, "Recovery_AOE")
