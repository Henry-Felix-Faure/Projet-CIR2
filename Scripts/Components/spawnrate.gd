class_name Spawnrate
extends Marker2D

var bank_mob = {}
var etat = []
var etat_now = 0 

func _ready() -> void:
	var time = Timer.new()
	var time2 = Timer.new()
	time.autostart = true
	time2.autostart = true
	time.wait_time = 5
	time2.wait_time = 20
	add_child(time)
	add_child(time2)
	time.start()
	time2.start()
	time.timeout.connect(_on_timeout)
	time2.timeout.connect(change_etat)
	bank_mob["mob1"] = 100
	bank_mob["mob2"] = 0
	bank_mob["mob2"] = 0
	bank_mob["mob3"] = 0
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


func choose_mob(spawn_rate = bank_mob):
	var random_nb = randf_range(1,100)
	var somme = 0
	for cle in spawn_rate:
		if random_nb > somme and random_nb <= somme + spawn_rate[cle]:
			#spawn avec la cle
			break
		somme += spawn_rate[cle]


func _on_timeout() -> void:
	choose_mob()


func change_etat() -> void:
	var idx = 0
	for cle in bank_mob:
		bank_mob[cle] = etat[etat_now][idx]
		idx += 1
	etat_now += 1
