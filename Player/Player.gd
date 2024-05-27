extends CharacterBody2D

# importing initial variable linked to the CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_area_2d: HurtboxComponent = $HurtboxArea2D
@onready var stats_component: StatsComponent = $StatsComponent
@onready var sword_area_2d: HitboxComponent = $SwordArea2D
@onready var explosion_particles: CPUParticles2D = $CPUParticles2D
@onready var blood_particles: CPUParticles2D = $BloodParticles
@onready var dash_timer: Timer = $Dash_cd
@onready var parry_timer: Timer = $Parry_cd
@onready var atk_1_cd: Timer = $ATK_1_cd
@onready var dash_cd_indicator: Control = get_parent().get_node("UI").get_node("dash_cd_indicator")
@onready var parry_cd_indicator: Control = get_parent().get_node("UI").get_node("parry_cd_indicator")

# importing initial stats variables
@onready var max_health: int = stats_component.max_health
@onready var health: int = max_health
@onready var crit_chance: float = stats_component.crit_chance
@onready var damage: int = stats_component.dmg
@onready var crit_damage: float = stats_component.damage_crit
@onready var dash_cd: float = stats_component.dash_cd
@onready var parry_cd: float = stats_component.parry_cd
@onready var atk_speed: float = stats_component.atk_speed
@onready var parry_lvl: int = stats_component.parry_lvl
@onready var xp: int = stats_component.xp
@onready var xp_lvl_up: int = stats_component.xp_lvl_up


var cancel_dash_parry: bool = false
var parrying: bool = false

signal critical_hit

#@onready var MAX_SPEED: int = 1000
@onready var BASE_SPEED: int = stats_component.speed_up
@onready var DASH_SPEED: int = stats_component.dash_speed

#var ACCELERATION: int = 100000000
#var FRICTION: int = 100000000
var input_vector: Vector2 = Vector2.ZERO # Vector2 of the current input
var last_input_vector: Vector2 = Vector2.ZERO # Vector2 of the last input
var last_dir: Vector2 = Vector2(0, 1) # Vector2 of the last direction faced for animations
var attack_left: int = 3 # number of attack that you can still perform (currently the combo is 3)
var attacks_array: Array = [
	["atk_right_1", "atk_right_2", "atk_right_3"], 
	["atk_down_1", "atk_down_2", "atk_down_3"], 
	["atk_up_1", "atk_up_2", "atk_up_3"]
] # array of array for each 3 attacks of each 4 four directions (left and right are the same)
var cancel_dash_attack: bool = false
var dashing: bool = false

# aiming with mouse
@export var AIMING_MOUSE: bool # boolean variable to enable / disable aiming for attack with mouse instead of keyboard
var cursor_pos_from_player: Vector2 # Vector2 to store the difference between cursor position and player position 
var cursor_pos_attack_array: Array = [] # array of array for each 3 attacks of each 4 four directions (left and right are the same)
var last_dir_attack_array: Array = [] # array of array for each 3 attacks of each 4 four directions (left and right are the same)

@onready var stats_array: Dictionary = {"base speed" : BASE_SPEED, "dash speed" : DASH_SPEED, "dash cd" : dash_cd, "parry cd" : parry_cd, "atk speed" : atk_speed, "parry lvl" : parry_lvl, "dmg" : damage, "crit chance" : crit_chance, "dmg crit" : crit_damage, "health" : health, "max health" : max_health, "xp" : xp, "xp_lvl_up" : xp_lvl_up}

func _ready():
	dash_timer.wait_time = dash_cd
	parry_timer.wait_time = parry_cd
	stats_component.stat_changed.connect(update_stats)

func _physics_process(_delta): 
	pass

func update_stats():
	BASE_SPEED = stats_component.speed_up
	DASH_SPEED = stats_component.dash_speed
	dash_cd = stats_component.dash_cd
	parry_cd = stats_component.parry_cd
	atk_speed = stats_component.atk_speed
	parry_lvl = stats_component.parry_lvl
	damage = stats_component.dmg
	crit_chance = stats_component.crit_chance
	crit_damage = stats_component.damage_crit
	max_health = stats_component.max_health
	health = stats_component.health
	xp = stats_component.xp
	xp_lvl_up = stats_component.xp_lvl_up
	dash_timer.wait_time = dash_cd
	parry_timer.wait_time = parry_cd
	dash_cd_indicator.progress_bar.max_value = dash_cd
	parry_cd_indicator.progress_bar.max_value = parry_cd
	stats_array = {"base speed" : BASE_SPEED, "dash speed" : DASH_SPEED, "dash cd" : dash_cd, "parry cd" : parry_cd, "atk speed" : atk_speed, "parry lvl" : parry_lvl, "dmg" : damage, "crit chance" : crit_chance, "dmg crit" : crit_damage, "health" : health, "max health" : max_health, "xp" : xp, "xp_lvl_up" : xp_lvl_up}
