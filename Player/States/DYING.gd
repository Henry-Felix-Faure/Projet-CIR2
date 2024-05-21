extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var hurtbox_area_2d: HurtboxComponent = $"../../HurtboxArea2D"
@onready var collision_shape_2d: CollisionShape2D = $"../../CollisionShape2D"

func Enter():
	hurtbox_area_2d.is_invincible = true # disabling the hurtbox of the player
	collision_shape_2d.set_deferred("disabled", true) # disabling the hitbox of the player
	animated_sprite_2d.play("death") # playing the death animation
	await animated_sprite_2d.animation_finished # waiting for the animation to finish
	bob.queue_free() # deleting the player from the scene
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
