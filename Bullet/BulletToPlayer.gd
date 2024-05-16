extends Area2D

@onready var visible_on_screen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@export var SPEED : int
@export var hitbox_component: HitboxComponent


var damage : int = 2

func _ready():
	visible_on_screen.screen_exited.connect(queue_free)

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1000
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta 
		

func _on_body_entered(body):
	queue_free()

func set_layer(mask : int) -> void : 
	hitbox_component.set_collision_mask_value(mask, true)
