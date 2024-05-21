extends Camera2D

@onready var camera_2d = $"."
var shake_amount : float = 0
var default_offset : Vector2 = offset
var pos_x : int #number
var pos_y : int
@onready var timer: Timer = $"../ShakeTimer"

func _ready():
	set_process(true)
	camera_2d = self
	randomize()
	
func _process(_delta: float):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func shake(time: float, amount: float):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()

func _on_timer_timeout() -> void:
	set_process(false)
