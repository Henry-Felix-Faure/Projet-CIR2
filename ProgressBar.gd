extends ProgressBar

@onready var Bob = $"../../Bob"

func ready():
	update()
	
func update():
	value = Bob.health * 100 
