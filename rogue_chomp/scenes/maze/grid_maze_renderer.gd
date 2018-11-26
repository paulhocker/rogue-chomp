extends "./maze_renderer.gd"

onready var tile_map = $TileMap

onready var floor_tile = tile_map.tile_set.find_tile_by_name("grid_1")
onready var wall_tile = tile_map.tile_set.find_tile_by_name("grid_2")

func render(width, height, maze):
	 
	.render(width, height, maze)
	
	Logger.trace('grid_maze_renderer.render')
	
	var pos
	
	for x in range(width + 2):
		pos = Vector2(x-1, -1)
		tile_map.set_cellv(pos, wall_tile)
		pos = Vector2(x-1, height)
		tile_map.set_cellv(pos, wall_tile)
		
	for y in range(height):
		pos = Vector2(-1, y)
		tile_map.set_cellv(pos, wall_tile)
		pos = Vector2(width, y)
		tile_map.set_cellv(pos, wall_tile)
		

	for y in range(height):
		for x in range(width):
			pos = Vector2(x, y)
			if _get_tile_at_position(x, y) == ".":
				tile_map.set_cellv(pos, floor_tile)
			else:
				tile_map.set_cellv(pos, wall_tile)
				
	