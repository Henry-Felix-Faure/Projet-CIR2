extends CharacterBody2D

# importing initial variable linked to the CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurtbox_area_2d: HurtboxComponent = $HurtboxArea2D
@onready var stats_component: StatsComponent = $StatsComponent
@onready var sword_area_2d: HitboxComponent = $SwordArea2D
@onready var explosion_particles: CPUParticles2D = $CPUParticles2D

# importing initial stats variables
@onready var health: int = stats_component.health
@onready var crit_chance: float = stats_component.crit
@onready var damage: int = stats_component.dmg
@onready var crit_damage: float = stats_component.damage_crit


var cancel_dash_parry: bool = false
var parrying: bool = false

signal critical_hit


@onready var MAX_SPEED: int = 1000
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

func _ready():
	pass

func _physics_process(_delta): 
	pass
