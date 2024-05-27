extends State

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var atilla: CharacterBody2D = $"../.."

func Enter():
	animated_sprite_2d.play("dash_right",0.5)
	animated_sprite_2d.offset.y = -25
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 1.5
	timer.start()
	timer.timeout.connect(timer_timeout)

func Exit():
	animated_sprite_2d.offset.y = 0

func Update(delta):
	var y = 0
	if animated_sprite_2d.offset.y < 0:
		animated_sprite_2d.offset.y += 0.2
		y = -0.2
	var mouvement = Vector2(1, y).normalized()
	atilla.velocity = mouvement * 50
	atilla.move_and_collide(atilla.velocity * delta)

func timer_timeout():
	state_transition.emit(self, "Move")
