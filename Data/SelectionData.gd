class_name LevelUpTree
extends Node

signal speedUp
signal droneUp
signal atkUp

var allPath : Array
var pathSpeed : Dictionary = {
	0: {
		"name": "On va vite ou quoi ?\n\n",
		"desc": "SpeedBoost",
		"call": Callable(self,"addSpeed"),
		"value": 0.2,
		},
	1:{
		"name" : "On va vite ou quoi ? 2\n\n",
		"desc": "SpeedBoost",
		"call": Callable(self,"addSpeed"),
		"value": 0.2,
	}}
var dronePath : Dictionary = {
	0: {
		"name": "On va drone ou quoi ?\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 0
		},
	1: {
		"name": "On va drone ou quoi ? 2\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 7
		},
	2: {
		"name": "On va drone ou quoi ? 3\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 8
		},
	3: {
		"name": "On va drone ou quoi ? 4\n\n",
		"desc": "DroneBoost",
		"call": Callable(self,"droneUpgrade"),
		"value": 10
		}
}
var atkUpPath : Dictionary = {
	0: {
		"name": "On va atkUp ou quoi ?\n\n",
		"desc": "atkUP",
		"call": Callable(self,"addAtk"),
		"value": 0.2
		}
}
func _ready() -> void:
	allPath.append([pathSpeed,0])
	allPath.append([dronePath,0])
	allPath.append([atkUpPath, 0])
	
func _GetUpgrade() -> Array:
	var rng = RandomNumberGenerator.new()
	var indice : int = rng.randi_range(0,2)
	print(indice)
	return allPath[indice]

func addSpeed(speed : float):
	speedUp.emit(speed)

func addAtk(atk : int):
	atkUp.emit(atk)

func droneUpgrade(lvl : int):
	droneUp.emit(lvl)
