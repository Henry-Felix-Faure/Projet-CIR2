extends AnimatedSprite2D

@onready var ennemie_detection: Area2D = $EnnemieDetection
@onready var muzzle: Marker2D = $Muzzle
@onready var spawn_component: SpawnComponent = $SpawnComponent
@onready var atks: Timer = $Timer

func _ready() -> void: 
	atks.wait_time = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees += 1
	var enemies_in_range = ennemie_detection.get_overlapping_areas()
	if enemies_in_range.size() > 0 and atks.is_stopped():
		# Recherche de la cible la plus proche parmi tous les ennemis dans la zone de détection
		var closest_enemy = null
		var closest_distance = 1000
		var current_target
		for enemy in enemies_in_range:
			var distance_to_enemy = global_position.distance_to(enemy.global_position)
			if distance_to_enemy < closest_distance:
					closest_enemy = enemy
					closest_distance = distance_to_enemy
			if closest_enemy:
				current_target = closest_enemy
		shoot(current_target)
		atks.start()
		
func shoot(ennemie) -> void : 
	var  ennemie_pos: Vector2 = ennemie.global_position
	var bullet : Node2D = spawn_component.spawn(muzzle.global_position)
	var v = ennemie_pos - bullet.global_position
	var angle = v.angle()
	bullet.rotation = angle
	print_debug("CACA")
	bullet.damage = 10
