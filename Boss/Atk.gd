extends State

@onready var atilla: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
var player : CharacterBody2D
var knives : Array
var x = [-25, 25, 25 ,-25]
var y = [0, 0, 20, 20]
func Enter():
	knives = []
	player = atilla.get_parent().get_node("Bob")
	animated_sprite_2d.play("atk_left")
	for i in range(4):
		var instance = preload("res://Boss/boss_bullet.tscn").instantiate()
		get_parent().get_parent().add_child(instance)
		knives.append(instance)
		instance.position.x += x[i]
		instance.position.y += y[i]

func Update(_delta):
	if animated_sprite_2d.frame == 13:
		for knife in knives:
			var v = player.global_position - knife.global_position
			var angle = v.angle()
			knife.rotation = angle
			knife.SPEED = 500
			knife.turning = false

func animation_finished():
	state_transition.emit(self, "Recovery")
