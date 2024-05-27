extends State

@onready var atilla: CharacterBody2D = $"../.."


func Enter():
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 1.5
	timer.start()
	timer.timeout.connect(timer_timeout)

func Exit():
	atilla.is_atk_cd = true
	atilla.atk_cd.start()

func timer_timeout():
	state_transition.emit(self, "Move")
