# Give the component a class name so it can be instanced as a custom node
class_name StatsComponent
extends Node

@onready var level_up_menu: Control = get_node("../../Level Up Menu")

# Create the health variable and connect a setter
@export var speed_up : float = 1
@export var dash_speed: float = 1
@export var dash_cd : float = 2
@export var parry_cd : float = 1.5
@export var atk_speed : float = 1
@export var parry_duration : float = 1
@export var dmg : int = 1
@export var crit : float = 0
@export var damage_crit : float = 1.20
@export var health: int = 1:
	set(value):
		health = value
		# Signal out that the health has changed
		health_changed.emit()
		# Signal out when health is at 0
		if health == 0: no_health.emit()
# Create our signals for health
signal health_changed() # Emit when the health value has changed
signal no_health() # Emit when there is no health left

func _ready() -> void:
	var level_up_tree : LevelUpTree = level_up_menu.level_up_tree
	level_up_tree.speedUp.connect(up_speed)
	level_up_tree.droneUp.connect(up_drone)
	level_up_tree.atkUp.connect(up_atk)

func up_speed(speed):
	speed_up += speed
	
func up_atk(atk):
	dmg += atk
func up_drone(indice):
	pass
