extends Control

var speed = 1000
var rotation_speed = 0.3
var direction = Vector2(-1, 0)

@onready var parallax = %ParallaxBackground2

func _process(delta):
	parallax.scroll_offset += direction * speed * delta

func show_and_hide(first, second):
	first.show()
	second.hide()
	#direction = direction.rotated(rotation_speed * delta)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Map/world.tscn")


func _on_quit_pressed():
	get_tree().quit()
	
func _on_option_pressed():
	show_and_hide(%Option, %test)

func _on_video_pressed():
	show_and_hide(%Video, %Option)

func _on_audio_pressed():
	show_and_hide(%Audio, %Option)

func _on_controle_pressed():
	show_and_hide(%Control, %Option)



func _on_back_vdo_pressed():
	show_and_hide(%Option, %Video)

func _on_back_odio_pressed():
	show_and_hide(%Option, %Audio)

func _on_back_opt_pressed():
	show_and_hide(%test, %Option)
	
func _on_button_key_pressed():
	show_and_hide(%Option, %Control)


