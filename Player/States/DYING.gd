extends State

@onready var bob: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var hurtbox_area_2d: HurtboxComponent = $"../../HurtboxArea2D"
@onready var collision_shape_2d: CollisionShape2D = $"../../CollisionShape2D"

@onready var world: Node2D = bob.get_parent()
@onready var death_screen = preload("res://Assets/death_screen.tscn")

func Enter():
	animated_sprite_2d.speed_scale = 1
	animation_player.speed_scale = 1
	hurtbox_area_2d.is_invincible = true # disabling the hurtbox of the player
	collision_shape_2d.set_deferred("disabled", true) # disabling the hitbox of the player
	animated_sprite_2d.play("death") # playing the death animation
	
	for node in world.get_children():
		if node.name != "Bob":
			node.queue_free()	
	
	bob.get_node("spawn_zone").queue_free()
	var death_scene = death_screen.instantiate()
	add_child(death_scene)
	death_scene.position = bob.position
	death_scene.visible = true	
	
func Exit():
	pass
	
func Update(_delta:float):
	pass
	
func animation_finished():
	bob.queue_free() # deleting the player from the scene
	get_tree().change_scene_to_file("res://Menu/MenuStart/MenuStart.tscn")
