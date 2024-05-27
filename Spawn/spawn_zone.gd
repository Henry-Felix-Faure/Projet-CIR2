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
const boss = preload("res://Boss/atilla.tscn")

var bank_mob = {"robot": 100, "police": 0, "kamikaze": 0, "riotman": 0}

var etat = []
var etat_now = 0 

func _ready() -> void:
	timer_spawn.timeout.connect(_spawn_mob)
	timer_state.timeout.connect(change_etat)
	timer_spawn.wait_time = 6
	timer_state.wait_time = 60
	
	etat = [[80,18,2,0,0],
	[60,35,5,0,0],
	[34,44,20,2,0],
	[20,35,35,10,0],
	[0,18,60,20,2],
	[0,18,60,20,2],
	[0,0,44,44,10],
	[0,0,15,50,20],
	[0,0,10,35,55]]



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
	if etat_now == 5 and etat_now == 10:
		mob_spawn = boss.instantiate()
		get_parent().get_parent().add_child(mob_spawn)
	else :
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
	if etat_now < 10:
		timer_spawn.wait_time -= 0.5
		if etat_now == 5 :
			pass
		var idx = 0
		for cle in bank_mob:
			bank_mob[cle] = etat[etat_now][idx]
			if idx >= 5:
				pass
			else:
				idx += 1
		etat_now += 1
