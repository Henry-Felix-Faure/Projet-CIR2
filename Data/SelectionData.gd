class_name LevelUpTree
extends Node

signal speedUp
signal droneUp
signal atkUp
signal up_dash_speed
signal up_dash_cd
signal up_parry_cd
signal up_atk_speed
signal up_parry_lvl
signal up_crit_chance
signal up_damage_crit
signal up_max_health
signal up_regen
@onready var drone_menu = get_parent().get_parent().get_child(0)

const ATK_SPEED_UP_1 = preload("res://Assets/PowerUp/atk_speed_up_1.png")
const ATK_SPEED_UP_2 = preload("res://Assets/PowerUp/atk_speed_up_2.png")
const ATK_SPEED_UP_3 = preload("res://Assets/PowerUp/atk_speed_up_3.png")
const ATK_UP_1 = preload("res://Assets/PowerUp/atk_up_1.png")
const ATK_UP_2 = preload("res://Assets/PowerUp/atk_up_2.png")
const ATK_UP_3 = preload("res://Assets/PowerUp/atk_up_3.png")
const CRIT_RATE_UP_1 = preload("res://Assets/PowerUp/crit_rate_up_1.png")
const CRIT_RATE_UP_2 = preload("res://Assets/PowerUp/crit_rate_up_2.png")
const CRIT_RATE_UP_3 = preload("res://Assets/PowerUp/crit_rate_up_3.png")
const CRIT_UP_1 = preload("res://Assets/PowerUp/crit_up_1.png")
const CRIT_UP_2 = preload("res://Assets/PowerUp/crit_up_2.png")
const CRIT_UP_3 = preload("res://Assets/PowerUp/crit_up_3.png")
const DASH_COOLDOWN_1 = preload("res://Assets/PowerUp/dash_cooldown_1.png")
const DASH_COOLDOWN_2 = preload("res://Assets/PowerUp/dash_cooldown_2.png")
const DASH_COOLDOWN_3 = preload("res://Assets/PowerUp/dash_cooldown_3.png")
const DASH_SPEED_UP_1 = preload("res://Assets/PowerUp/dash_speed_up_1.png")
const DASH_SPEED_UP_2 = preload("res://Assets/PowerUp/dash_speed_up_2.png")
const DASH_SPEED_UP_3 = preload("res://Assets/PowerUp/dash_speed_up_3.png")
const DRONE_NORMAL = preload("res://Assets/PowerUp/drone_normal.png")
const MAX_HEALTH_UP_1 = preload("res://Assets/PowerUp/health_up_1.png")
const MAX_HEALTH_UP_2 = preload("res://Assets/PowerUp/health_up_2.png")
const MAX_HEALTH_UP_3 = preload("res://Assets/PowerUp/health_up_3.png")
const PARRY_COOLDOWN_1 = preload("res://Assets/PowerUp/parry_cooldown_1.png")
const PARRY_COOLDOWN_2 = preload("res://Assets/PowerUp/parry_cooldown_2.png")
const PARRY_COOLDOWN_3 = preload("res://Assets/PowerUp/parry_cooldown_3.png")
const PARRY_UP_1 = preload("res://Assets/PowerUp/parry_up_1.png")
const PARRY_UP_2 = preload("res://Assets/PowerUp/parry_up_2.png")
const PARRY_UP_3 = preload("res://Assets/PowerUp/parry_up_3.png")
const REGEN_UP_1 = preload("res://Assets/PowerUp/regen_up_1.png")
const REGEN_UP_2 = preload("res://Assets/PowerUp/regen_up_2.png")
const REGEN_UP_3 = preload("res://Assets/PowerUp/regen_up_3.png")
const SPEED_UP_1 = preload("res://Assets/PowerUp/speed_up_1.png")
const SPEED_UP_2 = preload("res://Assets/PowerUp/speed_up_2.png")
const SPEED_UP_3 = preload("res://Assets/PowerUp/speed_up_3.png")


var allPath : Array
var pathSpeed : Dictionary = {
	0: {
		"name": "Implants d'Achilles\n\n",
		"desc": "Augmente la vitesse de déplacement",
		"call": Callable(self,"addSpeed"),
		"value": 10,
		"icon": SPEED_UP_1
		},
	1:{
		"name" : "Amélioration des implants d'Achilles\n\n",
		"desc": "Augmente la vitesse de déplacement",
		"call": Callable(self,"addSpeed"),
		"value": 10,
		"icon": SPEED_UP_2
	},
	2:{
		"name" : "Amélioration des implants d'Achilles\n\n",
		"desc": "Augmente la vitesse de déplacement",
		"call": Callable(self,"addSpeed"),
		"value": 20,
		"icon": SPEED_UP_3
	},}
var dronePath : Dictionary = {
	0: {
		"name": "Besoins d'un copain ?\n\n",
		"desc": "Un drone pour t'aider, ca peut être utile !",
		"call": Callable(self,"droneUpgrade"),
		"value": 0,
		"icon": DRONE_NORMAL
		},
	1: {
		"name": "Etudes d'ingénieurs\n\n",
		"desc": "Ton drone passe aux choses sérieusess",
		"call": Callable(self,"droneUpgrade"),
		"value": 1,
		"icon": DRONE_NORMAL
		},
	2: {
		"name": "On va drone ou quoi ? 3\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 2,
		"icon": DRONE_NORMAL
		},
	3: {
		"name": "On va drone ou quoi ? 4\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 3,
		"icon": DRONE_NORMAL
		},
	4: {
		"name": "On va drone ou quoi ? 2\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 4,
		"icon": DRONE_NORMAL
		},
	5: {
		"name": "On va drone ou quoi ? 3\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 5,
		"icon": DRONE_NORMAL
		},
	6: {
		"name": "On va drone ou quoi ? 4\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 6,
		"icon": DRONE_NORMAL
		},
	7: {
		"name": "On va drone ou quoi ? 2\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 7,
		"icon": DRONE_NORMAL
		},
	8: {
		"name": "On va drone ou quoi ? 3\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 8,
		"icon": DRONE_NORMAL
		},
	9: {
		"name": "On va drone ou quoi ? 4\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 10,
		"icon": DRONE_NORMAL
		}
}
var atkUpPath : Dictionary = {
	0: {
		"name": "Le bras de Damia\n\n",
		"desc": "C'est pas encore ca, mais on commence a voir le biceps (attaque +)",
		"call": Callable(self,"addAtk"),
		"value": 1,
		"icon" : ATK_UP_1
		},
	1: {
		"name": "Le bras d'Edgar\n\n",
		"desc": "A la t'es BG ! (attaque +)",
		"call": Callable(self,"addAtk"),
		"value": 1,
		"icon" : ATK_UP_2
		},
	2: {
		"name": "Le bras de Clarence\n\n",
		"desc": "T'as mangé quoi pour devenir comme ca ? (attaque +)",
		"call": Callable(self,"addAtk"),
		"value": 2,
		"icon" : ATK_UP_3
		}
}

var dashSpeedUpPath : Dictionary = {
	0: {
		"name": "    Boost de puissance des jambes bioniques\n\n",
		"desc": "Augmente la vitesse du dash",
		"call": Callable(self,"dash_speed"),
		"value": 20,
		"icon" : DASH_SPEED_UP_1
		},
	1: {
		"name": "    Boost de puissance des jambes bioniques\n\n",
		"desc": "Augmente la vitesse du dash",
		"call": Callable(self,"dash_speed"),
		"value": 20,
		"icon" :  DASH_SPEED_UP_2
		},
	2: {
		"name": "    Boost de puissance des jambes bioniques\n\n",
		"desc": "Augmente la vitesse du dash",
		"call": Callable(self,"dash_speed"),
		"value": 20,
		"icon" :  DASH_SPEED_UP_3
		}
}

var dashCDUpPath: Dictionary = {
	0: {
		"name": "Installation de condensateurs\n\n",
		"desc": "Réduit le temps de recharge du dash",
		"call": Callable(self,"dash_cd"),
		"value": 1.0,
		"icon" : DASH_COOLDOWN_1
		},
	1: {
		"name": "Installation de batteries\n\n",
		"desc": "Réduit le temps de recharge du dash",
		"call": Callable(self,"dash_cd"),
		"value": 1.0,
		"icon" :  DASH_COOLDOWN_2
		},
	2: {
		"name": "Installation de volants d'inertie\n\n",
		"desc": "Réduit le temps de recharge du dash",
		"call": Callable(self,"dash_cd"),
		"value": 2.0,
		"icon" :  DASH_COOLDOWN_3
		}
}

var parryCDUpPath: Dictionary = {
	0: {
		"name": "On va up_parry_cd ou quoi ?\n\n",
		"desc": "up_parry_cd",
		"call": Callable(self,"parry_cd"),
		"value": 0.5,
		"icon" : PARRY_COOLDOWN_1
		},
	1: {
		"name": "On va up_parry_cd ou quoi ?\n\n",
		"desc": "up_parry_cd",
		"call": Callable(self,"parry_cd"),
		"value": 0.5,
		"icon" :  PARRY_COOLDOWN_2
		},
	2: {
		"name": "On va up_parry_cd ou quoi ?\n\n",
		"desc": "up_parry_cd",
		"call": Callable(self,"parry_cd"),
		"value": 1.0,
		"icon" :  PARRY_COOLDOWN_3
		}
}

var atkSpeedUpPath: Dictionary = {
	0: {
		"name": "On va up_atk_speed ou quoi ?\n\n",
		"desc": "up_atk_speed",
		"call": Callable(self,"atk_speed"),
		"value": 0.2,
		"icon" : ATK_SPEED_UP_1
		},
	1: {
		"name": "On va up_atk_speed ou quoi ?\n\n",
		"desc": "up_atk_speed",
		"call": Callable(self,"atk_speed"),
		"value": 0.2,
		"icon" :  ATK_SPEED_UP_2
		},
	2: {
		"name": "On va up_atk_speed ou quoi ?\n\n",
		"desc": "up_atk_speed",
		"call": Callable(self,"atk_speed"),
		"value": 0.2,
		"icon" :  ATK_SPEED_UP_3
		}
}

var parryUpPath: Dictionary = {
	0: {
		"name": "Acuité visuelle de 10/10\n\n",
		"desc": "Augmente la durée du parry",
		"call": Callable(self,"parry_lvl"),
		"value": 1,
		"icon" : PARRY_UP_2
		},
	1: {
		"name": "Yeux cybérnétique\n\n",
		"desc": "Augmente la durée du parry",
		"call": Callable(self,"parry_lvl"),
		"value": 1,
		"icon" :  PARRY_UP_3
		}
}


var critUpPath: Dictionary = {
	0: {
		"name": "On va up_crit_chance ou quoi ?\n\n",
		"desc": "up_crit_chance",
		"call": Callable(self,"crit_chance"),
		"value": 0.2,
		"icon" : CRIT_RATE_UP_1
		},
	1: {
		"name": "On va up_crit_chance ou quoi ?\n\n",
		"desc": "up_crit_chance",
		"call": Callable(self,"crit_chance"),
		"value": 0.2,
		"icon" :  CRIT_RATE_UP_2
		},
	2: {
		"name": "On va up_crit_chance ou quoi ?\n\n",
		"desc": "up_crit_chance",
		"call": Callable(self,"crit_chance"),
		"value": 0.2,
		"icon" :  CRIT_RATE_UP_3
		}
}

var damageCritUpPath: Dictionary = {
	0: {
		"name": "On va up_damage_crit ou quoi ?\n\n",
		"desc": "up_damage_crit",
		"call": Callable(self,"damage_crit"),
		"value": 0.3,
		"icon" : CRIT_UP_1
		},
	1: {
		"name": "On va up_damage_crit ou quoi ?\n\n",
		"desc": "up_damage_crit",
		"call": Callable(self,"damage_crit"),
		"value": 0.3,
		"icon" :  CRIT_UP_2
		},
	2: {
		"name": "On va up_damage_crit ou quoi ?\n\n",
		"desc": "up_damage_crit",
		"call": Callable(self,"damage_crit"),
		"value": 0.2,
		"icon" :  CRIT_UP_3
		}
}

var maxHealthUpPath: Dictionary = {
	0: {
		"name": "Installation du défibrilateur\n\n",
		"desc": "Augmente la santé maximum",
		"call": Callable(self,"max_health"),
		"value": 5,
		"icon" : MAX_HEALTH_UP_1
		},
	1: {
		"name": "Pompe cardiaque\n\n",
		"desc": "Augmente la santé maximum",
		"call": Callable(self,"max_health"),
		"value": 10,
		"icon" :  MAX_HEALTH_UP_2
		},
	2: {
		"name": "Coeur artificiel\n\n",
		"desc": "Augmente la santé maximum",
		"call": Callable(self,"max_health"),
		"value": 15,
		"icon" :  MAX_HEALTH_UP_3
		}
}

var RegenUpPath: Dictionary = {
	0: {
		"name": "Regen\n\n",
		"desc": "regen",
		"call": Callable(self,"regen_up"),
		"value": 5,
		"icon" : REGEN_UP_1
		},
	1: {
		"name": "Regen\n\n",
		"desc": "regen",
		"call": Callable(self,"regen_up"),
		"value": 10,
		"icon" :  REGEN_UP_2
		},
	2: {
		"name": "Regen\n\n",
		"desc": "regen",
		"call": Callable(self,"regen_up"),
		"value": 15,
		"icon" :  REGEN_UP_3
		}
}

func _ready() -> void:
	drone_menu.choosen.connect(drone_mode)
	allPath.append([pathSpeed,0])
	allPath.append([dronePath,0])
	allPath.append([atkUpPath, 0])
	allPath.append([dashSpeedUpPath,0])
	allPath.append([dashCDUpPath,0])
	allPath.append([parryCDUpPath, 0])
	allPath.append([atkSpeedUpPath, 0])
	allPath.append([parryUpPath, 0])
	allPath.append([critUpPath, 0])
	allPath.append([damageCritUpPath, 0])
	allPath.append([maxHealthUpPath, 0])
	allPath.append([RegenUpPath, 0])
	
func _GetUpgrade() -> Array:
	var rng = RandomNumberGenerator.new()
	var indice : int = rng.randi_range(0,allPath.size() - 1)
	return allPath[indice]

func addSpeed(speed : float, choice : Array, choice_i : int):
	speedUp.emit(speed)
	if  choice_i == 2: allPath.remove_at(allPath.find(choice, 0))
	
func addAtk(atk : int, choice : Array , choice_i : int):
	atkUp.emit(atk)
	if  choice_i== 2: allPath.remove_at(allPath.find(choice, 0))
	
func droneUpgrade(lvl : int, choice : Array = [], _choice_i : int = 0):
	if lvl == 1:
		drone_menu.show_drone_menu()
		return
	if lvl == 3 || lvl == 7 || lvl == 10:
		allPath.remove_at(allPath.find(choice, 0))
	droneUp.emit(lvl)

func drone_mode(mode):
	allPath[allPath.find(dronePath,0)][1] = mode + 1
	droneUp.emit(mode)
	
func dash_speed(up, choice : Array, choice_i : int):
	up_dash_speed.emit(up)
	if choice_i == 2: allPath.remove_at(allPath.find(choice, 0))
	
func dash_cd(up, choice : Array, choice_i : int):
	up_dash_cd.emit(up)
	if choice_i == 2: allPath.remove_at(allPath.find(choice, 0))
	
func parry_cd(up, choice : Array, choice_i: int):
	up_parry_cd.emit(up)
	if choice_i == 2: allPath.remove_at(allPath.find(choice, 0))
	
func atk_speed(up, choice : Array, choice_i: int):
	up_atk_speed.emit(up)
	if choice_i == 2: allPath.remove_at(allPath.find(choice, 0))
	
func parry_lvl(_up, choice : Array, choice_i: int):
	up_parry_lvl.emit()
	if choice_i == 1: allPath.remove_at(allPath.find(choice, 0))
	
func crit_chance(up, choice : Array, choice_i: int):
	up_crit_chance.emit(up)
	if choice_i == 2: allPath.remove_at(allPath.find(choice, 0))
	
func damage_crit(up, choice : Array, choice_i: int):
	up_damage_crit.emit(up)
	if choice_i == 2: allPath.remove_at(allPath.find(choice, 0))

func max_health(up, choice : Array, choice_i: int):
	up_max_health.emit(up)
	if choice_i == 2: allPath.remove_at(allPath.find(choice, 0))

func regen_up(up, choice : Array, choice_i: int):
	up_regen.emit()
	if choice_i == 2: allPath.remove_at(allPath.find(choice, 0))
