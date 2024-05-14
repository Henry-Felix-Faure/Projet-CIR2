class_name CriticalComponent
extends Node

@export var hurt_component : HurtComponent
@export var animated_sprite_2D : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurt_component.critical_hit.connect(critical_animation)

func critical_animation():
	#TODO EffectWhenCriticalPlay
	pass
