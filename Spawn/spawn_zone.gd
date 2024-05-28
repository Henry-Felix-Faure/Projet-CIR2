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
const sniper = preload("res://enemy/sniper_body.tscn")

var bank_mob = {"robot": 100, "police": 0, "kamikaze": 0, "sniper": 0, "riotman": 0}

var etat = []
var etat_now = 0 
var spawn_do : bool = true

func _ready() -> void:
	timer_spawn.timeout.connect(_spawn_mob)
	timer_state.timeout.connect(change_etat)
	timer_spawn.wait_time = 5
	timer_state.wait_time = 35
	
	etat = [[65,25,10,0,0],
	[45,35,5,10,5],
	[20,24,34,15,7],
	[5,15,40,25,15],
	[0,10,20,40,30],
	[0,5,15,40,40],
	[0,0,10,55,45],
	[0,0,5,40,55],
	[0,0,2,28,70]]



func _spawn_mob() -> void:
	var mob_spawn = ""
	var mob_choose = choose_mob()
	if etat_now == 5:
		print("boss spawn")
		mob_spawn = boss.instantiate()
	else:
		match mob_choose:
			"robot":
				mob_spawn = robot.instantiate()
			"police":
				mob_spawn = police.instantiate()
			"kamikaze":
				mob_spawn = kamikaze.instantiate()
			"riotman":
				mob_spawn = riotman.instantiate()
			"sniper":
				mob_spawn = sniper.instantiate()
	
	
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
	
	#if etat_now == 6 or etat_now == 11:
			#spawn_do = true
	
	if spawn_do :
		get_parent().get_parent().add_child(mob_spawn)
		if etat_now == 5:
			spawn_do = false
		
		

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
		timer_spawn.wait_time -= 0.8
		if etat_now >= 5 :
			spawn_do = false
		var idx = 0
		for cle in bank_mob:
			bank_mob[cle] = etat[etat_now][idx]
			if idx >= 5:
				pass
			else:
				idx += 1
		etat_now += 1
