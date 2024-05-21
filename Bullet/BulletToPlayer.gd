extends Node2D

@onready var visible_on_screen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@export var SPEED : int
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@export var direction = 0

var damage : int = 2

func _ready():
	visible_on_screen.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(_on_hurtbox_entered)
	hitbox_component.damage = damage
	
func _physics_process(delta):
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
func _on_hurtbox_entered(_body):
	pass
