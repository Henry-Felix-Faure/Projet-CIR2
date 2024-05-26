extends State


func Enter():
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 1.3
	timer.start()
	timer.timeout.connect(timer_timeout)
	
func timer_timeout():
	state_transition.emit(self, "Move")
