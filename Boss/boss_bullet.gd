extends AnimatedSprite2D

@export var SPEED : int
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@export var direction = 0

var destroy = false
var turning = true
var damage : int = 2

func _ready():
	hitbox_component.damage = damage
	
func _physics_process(delta):
	if turning:
		rotation_degrees += 25
	else :
		direction = Vector2.RIGHT.rotated(rotation)
		position += direction * SPEED * delta
	



func _on_timer_timeout() -> void:
	queue_free()
