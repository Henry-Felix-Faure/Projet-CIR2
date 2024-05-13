extends Control

func set_volume(idx,value):
	AudioServer.set_bus_volume_db(idx,linear_to_db(value))

func _on_master_value_changed(value):
	set_volume(0,value)


func _on_music_value_changed(value):
	set_volume(1,value)


func _on_sound_fx_value_changed(value):
	set_volume(2,value)
