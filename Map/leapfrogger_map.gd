extends Node2D

const tile_size: int = 16
const world_tile_size: int = 68

var current_world_layout = [["WT1", "WT2", "WT3"], ["WT4", "WT5", "WT6"], ["WT7", "WT8", "WT9"]]
var cardinal_dir_area = ["Area_north", "Area_west", "Area_east", "Area_south"]
var current_world_tile = null
var current_area = null

#@onready var pathfinding: Node2D = $Pathfinding

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	pass

func move_areas(dir: String):
	#var grid_pos
	match dir:
		"N":
			for area_name in cardinal_dir_area:
				current_area = get_node(area_name)
				current_area.position.y -= world_tile_size * tile_size
		"W":
			for area_name in cardinal_dir_area:
				current_area = get_node(area_name)
				current_area.position.x -= world_tile_size * tile_size
		"E":
			for area_name in cardinal_dir_area:
				current_area = get_node(area_name)
				current_area.position.x += world_tile_size * tile_size
		"S":
			for area_name in cardinal_dir_area:
				current_area = get_node(area_name)
				current_area.position.y += world_tile_size * tile_size

func _on_area_north_body_entered(body):
	if body.name == "Bob":
		var temp = []
		for world_tile_name in current_world_layout[2]:
			current_world_tile = get_node(world_tile_name)
			current_world_tile.position.y -= 3 * world_tile_size * tile_size
			
		temp = current_world_layout[2]
		current_world_layout[2] = current_world_layout[1]
		current_world_layout[1] = temp
		temp = current_world_layout[1]
		current_world_layout[1] = current_world_layout[0]
		current_world_layout[0] = temp
		move_areas("N")


func _on_area_west_body_entered(body):
	if body.name == "Bob":
		var temp: String
		for i in range(3):
			current_world_tile = get_node(current_world_layout[i][2])
			current_world_tile.position.x -= 3 * world_tile_size * tile_size
			
			temp = current_world_layout[i][2]
			current_world_layout[i][2] = current_world_layout[i][1]
			current_world_layout[i][1] = temp
			temp = current_world_layout[i][1]
			current_world_layout[i][1] = current_world_layout[i][0]
			current_world_layout[i][0] = temp
			
		move_areas("W")


func _on_area_east_body_entered(body):
	if body.name == "Bob":
		var temp: String
		for i in range(3):
			current_world_tile = get_node(current_world_layout[i][0])
			current_world_tile.position.x += 3 * world_tile_size * tile_size
			
			temp = current_world_layout[i][0]
			current_world_layout[i][0] = current_world_layout[i][1]
			current_world_layout[i][1] = temp
			temp = current_world_layout[i][1]
			current_world_layout[i][1] = current_world_layout[i][2]
			current_world_layout[i][2] = temp

		move_areas("E")


func _on_area_south_body_entered(body):
	if body.name == "Bob":
		var temp = []
		for world_tile_name in current_world_layout[0]:
			current_world_tile = get_node(world_tile_name)
			current_world_tile.position.y += 3 * world_tile_size * tile_size
				
		temp = current_world_layout[0]
		current_world_layout[0] = current_world_layout[1]
		current_world_layout[1] = temp
		temp = current_world_layout[1]
		current_world_layout[1] = current_world_layout[2]
		current_world_layout[2] = temp
		move_areas("S")
