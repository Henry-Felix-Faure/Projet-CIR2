extends State

@onready var physique_collision: CollisionShape2D = $"../../PhysiqueCollision"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var atilla: CharacterBody2D = $"../.."
var detected = false
var player : CharacterBody2D
func Enter():
	player = atilla.get_parent().get_node("Bob")
	animated_sprite_2d.play("dash_right")
	detected = false
func Update(delta):
	var p_x = player.position.x
	if p_x > atilla.position.x:
		animated_sprite_2d.flip_h = true
	else :
		animated_sprite_2d.flip_h = false
	if not detected:
		Move(delta)
	else :
		state_transition.emit(self, "aoe")

func Move(delta):
	var direction = atilla.global_position.direction_to(player.global_position)
	atilla.velocity = direction * 300 * delta 
	atilla.move_and_collide(atilla.velocity)


func _on_detect_player_2_body_entered(_body: Node2D) -> void:
	detected = true
