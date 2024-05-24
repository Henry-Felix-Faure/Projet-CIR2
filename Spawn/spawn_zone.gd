extends Node2D

@onready var spawn_top: ColorRect = $spawn_top
@onready var spawn_left: ColorRect = $spawn_left
@onready var spawn_right: ColorRect = $spawn_right
@onready var spawn_bottom: ColorRect = $spawn_bottom
@onready var timer_spawn: Timer = $Timer_spawn
@onready var timer_state: Timer = $Timer_state

const riotman = preload("res://enemy/CAC/riotman.tscn")
const police = preload("res://enemy/CAC/policeman.tscn")
const robot = preload("res://enemy/CAC/robot.tscn")
const kamikaze = preload("res://enemy/CAC/kamikaze_robot.tscn")

var bank_mob = {}
var etat = []
var etat_now = 0 

func _ready() -> void:
	timer_spawn.timeout.connect(_spawn_mob)
	timer_state.timeout.connect(change_etat)
	timer_spawn.wait_time = 5
	timer_state.wait_time = 10
	
	
	bank_mob["robot"] = 100
	bank_mob["police"] = 0
	bank_mob["kamikaze"] = 0
	bank_mob["riotman"] = 0
	bank_mob["mob4"] = 0
	bank_mob["mob5"] = 0
	bank_mob["mob6"] = 0
	
	etat = [[80,18,2,0,0,0],
	[60,35,5,0,0,0],
	[34,44,20,2,0,0],
	[20,35,35,10,0,0],
	[0,18,60,20,2,0],
	[0,0,44,44,10,2],
	[0,0,15,50,20,15],
	[0,0,0,20,50,30]]



func _spawn_mob() -> void:
	var mob_spawn = ""
	var mob_choose = choose_mob()
	match mob_choose:
		"robot":
			mob_spawn = robot.instantiate()
		"police":
			mob_spawn = police.instantiate()
		"kamikaze":
			mob_spawn = kamikaze.instantiate()
		"riotman":
			mob_spawn = riotman.instantiate()
	
	
	var random_spawn = randi() % 4
	var rect = 0
	match random_spawn:
		0:
			rect = spawn_top.get_global_rect()
		1:
			rect = spawn_right.get_global_rect()
		2:
			rect = spawn_bottom.get_global_rect()
		3:
			rect = spawn_left.get_global_rect()
			
	var mob_x = randf_range(rect.position.x, rect.end.x)
	var mob_y = randf_range(rect.position.y, rect.end.y)
	mob_spawn.position = Vector2(mob_x, mob_y)
	get_parent().get_parent().add_child(mob_spawn)
	
func choose_mob(spawn_rate = bank_mob):
	var random_nb = randf_range(1,100)
	var somme = 0
	for cle in spawn_rate:
		if random_nb > somme and random_nb <= somme + spawn_rate[cle]:
			return cle
			break
		somme += spawn_rate[cle]


func change_etat() -> void:
	var idx = -1
	for cle in bank_mob:
		bank_mob[cle] = etat[etat_now][idx]
		idx += 1
	etat_now += 1
