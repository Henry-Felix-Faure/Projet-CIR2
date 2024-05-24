# Give the component a class name so it can be instanced as a custom node
class_name StatsComponent
extends Node

signal health_changed() # Emit when the health value has changed
signal no_health() # Emit when there is no health left
signal lvl_up()

@onready var level_up_menu: Control = get_node("../../MenuLayer/Level Up Menu")
signal stat_changed


@export var xp_lvl_up : int = 10
@export var xp : int = 0 : 
	set(value):
		xp = value
		if xp == xp_lvl_up: 
			xp_lvl_up = xp_lvl_up * 1.25
			xp = 0
			level_up_menu._on_lvl_up()

var drone
var d_1 : bool = false
var d_2 : bool = false

# Create the health variable and connect a setter
@export var speed_up : int = 1
@export var dash_speed: int = 300
@export var dash_cd : float = 5.0
@export var parry_cd : float = 3.0
@export var atk_speed : float = 1.0
@export var parry_lvl : int = 1
@export var dmg : int = 1
@export var crit_chance : float = 0.0
@export var damage_crit : float = 1.2
@export var health: int = 20:
	set(value):
		health = value
		# Signal out that the health has changed
		health_changed.emit()
		# Signal out when health is at 0
		if health <= 0: no_health.emit()
# Create our signals for health


func _ready() -> void:
	if(get_parent().name == "Bob"):
		var level_up_tree : LevelUpTree = level_up_menu.level_up_tree
		level_up_tree.speedUp.connect(up_speed)
		level_up_tree.droneUp.connect(up_drone)
		level_up_tree.atkUp.connect(up_atk)
		level_up_tree.up_dash_speed.connect(up_dash_speed)
		level_up_tree.up_dash_cd.connect(up_dash_cd)
		level_up_tree.up_parry_cd.connect(up_parry_cd)
		level_up_tree.up_atk_speed.connect(up_atk_speed)
		level_up_tree.up_parry_lvl.connect(up_parry_lvl)
		level_up_tree.up_crit_chance.connect(up_crit_chance)
		level_up_tree.up_damage_crit.connect(up_damage_crit)
		level_up_tree.up_health.connect(up_health)
		

func up_speed(speed):
	speed_up += speed
	stat_changed.emit()
	
func up_atk(atk):
	dmg += atk
	stat_changed.emit()
	
func up_dash_speed(up):
	dash_speed += up
	stat_changed.emit()
	
func up_dash_cd(up):
	dash_cd -= up
	stat_changed.emit()
	
func up_parry_cd(up):
	parry_cd -= up
	stat_changed.emit()
	
func up_atk_speed(up):
	atk_speed += up
	stat_changed.emit()
	
func up_parry_lvl(): 
	parry_lvl +=1
	stat_changed.emit()
	
func up_crit_chance(up):
	crit_chance += up
	stat_changed.emit()
	
func up_damage_crit(up):
	damage_crit += up
	stat_changed.emit()
	
func up_health(up):
	health += up
	stat_changed.emit()
	
func up_drone(indice):
	match indice:
		0:	
			const load = preload("res://PowerUp/drone.tscn")
			var scene = load.instantiate()
			drone = scene
			get_parent().add_child(scene)
		#Path Sniper
		1:
			drone.damage = 10
			drone.bullet_speed = 400
			drone.atks.wait_time = 4
			drone.change_mode("Sniper")
		2:	
			drone.damage = 20
			drone.bullet_speed = 400
			drone.atks.wait_time = 3
		3:
			create_new_drone()
		#Path Turret
		4:
			drone.damage = 2
			drone.bullet_speed = 300
			drone.atks.wait_time = 0.5
			drone.change_mode("Turret")
			create_new_drone()
		5:
			create_new_drone()
		6:
			create_new_drone()
		#Path Melee
		7:
			drone.damage = 5
			drone.bullet_speed = 0
			drone.atks.wait_time = 32767
			drone.speed = 3
			drone.change_mode("Melee")
		8:
			create_new_drone()
		9:
			pass
		10:
			create_new_drone()
			create_new_drone()
			create_new_drone()

func create_new_drone():
	const load = preload("res://PowerUp/drone.tscn")
	var new_drone = load.instantiate()
	get_parent().add_child(new_drone)
	new_drone.change_mode(drone.TYPE.keys()[drone.mode])
	new_drone.damage = drone.damage
	new_drone.bullet_speed = drone.bullet_speed
	new_drone.speed = drone.speed
	new_drone.atks.wait_time = drone.atks.wait_time
	if not d_1:
		new_drone.rotation_degrees = drone.rotation_degrees + 180
		d_1 = true
	elif not d_2:
		new_drone.rotation_degrees = drone.rotation_degrees + 90
		d_2 = true
	else:
		new_drone.rotation_degrees = drone.rotation_degrees - 90

