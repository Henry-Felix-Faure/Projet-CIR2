extends Line2D

@export var lenght = 15
@onready var parent = get_parent()
@onready var ShaderDash = $"../ShaderDash"
@export var fade_out_time = 0.5  # Temps en secondes pour la disparition en fondu
var is_fading = false
var fade_timer = 0.0
var current_color = modulate


func _ready():
	top_level = true
	print(current_color)
	clear_points()
	
func _physics_process(delta):
	add_point(parent.global_position)
	
	if points.size() > lenght:
		remove_point(0)
	
	if is_fading:
		# Calculez l'opacité en fonction du temps écoulé et du temps de fondu
		var opacity = 1.0 - delta        # Appliquez l'opacité à la couleur
		default_color.a = opacity
		#change_line_color(Color(6, 5, 5, 1)) #rose # vert:(3, 19, 6, 1)
		
func start_fade_out():
	ShaderDash.start()
	is_fading = true

func _on_shader_dash_timeout():
	is_fading = false
	hide()

func change_line_color(color: Color):
	modulate = color
