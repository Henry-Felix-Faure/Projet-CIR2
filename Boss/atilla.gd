extends CharacterBody2D

@onready var player = get_parent().get_node("Bob")
@onready var aoe_cd: Timer = $AOE_cd
@onready var atk_cd: Timer = $Atk_cd
@onready var full_recovery: Timer = $FullRecovery

var is_aoe_cd = false
var is_atk_cd = false
var is_full_recovery = false

func _on_atk_cd_timeout() -> void:
	is_atk_cd = false

func _on_aoe_cd_timeout() -> void:
	is_aoe_cd = false

func _on_full_recovery_timeout() -> void:
	is_full_recovery = false