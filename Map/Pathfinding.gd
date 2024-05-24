extends Node2D
#
#@export var cell_size = Vector2(16, 16)
#
#@onready var wt_5: TileMap = $"../WT5"
#
#var astar_grid = AStarGrid2D.new()
#var grid_region
#var grid_pos: Vector2 = Vector2(-102.0 * 16.0, -102.0 * 16.0)
#var grid_size: Vector2 = Vector2( 204.0 * 16.0, 204.0 * 16.0)
#
#func initialize_grid():
	#grid_region = Rect2(grid_pos, grid_size)
	#astar_grid.region = grid_region
	#astar_grid.cell_size = cell_size
	#astar_grid.offset = cell_size / 2
	#astar_grid.update()
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#initialize_grid()
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
