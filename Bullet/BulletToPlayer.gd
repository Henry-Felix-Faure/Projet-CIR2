extends Area2D

@onready var visible_on_screen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready():
	visible_on_screen.screen_exited.connect(queue_free)

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1000
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta 
		

func _on_hurtbox_entered(_body):
	pass

