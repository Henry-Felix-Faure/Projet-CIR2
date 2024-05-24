extends Control

@onready var label = $Label
@onready var bob = get_parent().get_node("Bob")
@onready var old_stat = bob.stats_array

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in bob.stats_array.keys():
			label.text += str(key, " : ", bob.stats_array[key], "\n")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = bob.position + Vector2(25, 0)
	if old_stat != bob.stats_array:
		update_label()
	
	
func update_label():
	label.text = ""
	for key in bob.stats_array.keys():
			label.text += str(key, " : ", bob.stats_array[key], "\n")
	
