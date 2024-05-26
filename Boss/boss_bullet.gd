extends AnimatedSprite2D

@onready var visible_on_screen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@export var SPEED : int
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@export var direction = 0

var destroy = false
var turning = true
var damage : int = 2

func _ready():
	visible_on_screen.screen_exited.connect(queue_free)
	hitbox_component.damage = damage
	
func _physics_process(delta):
	if turning:
		rotation_degrees += 25
	else :
		direction = Vector2.RIGHT.rotated(rotation)
		position += direction * SPEED * delta
	

