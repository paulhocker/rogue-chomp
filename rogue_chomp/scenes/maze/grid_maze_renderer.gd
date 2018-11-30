extends "./maze_renderer.gd"

var tilemap

func render(maze):
	 
	.render(maze)
	
	Logger.trace('grid_maze_renderer.render')
		
	var floor_tile = tilemap.tile_set.find_tile_by_name("grid_1")
	var wall_tile = tilemap.tile_set.find_tile_by_name("grid_2")
	
	var pos
	
	for x in range(width + 2):
		pos = Vector2(x-1, -1)
		tilemap.set_cellv(pos, wall_tile)
		pos = Vector2(x-1, height)
		tilemap.set_cellv(pos, wall_tile)
		
	for y in range(height):
		pos = Vector2(-1, y)
		tilemap.set_cellv(pos, wall_tile)
		pos = Vector2(width, y)
		tilemap.set_cellv(pos, wall_tile)
		

	for y in range(height):
		for x in range(width):
			pos = Vector2(x, y)
			if get_tile_at_position(x, y) == ".":
				tilemap.set_cellv(pos, floor_tile)
			else:
				tilemap.set_cellv(pos, wall_tile)
				

func _init():
	tilemap = TileMap.new()
	tilemap.name = "TileMap"
	add_child(tilemap)
	tilemap.cell_size = Vector2(16, 16)
	tilemap.tile_set = load("res://rogue_chomp/tilesets/grid_tiles.tres")
