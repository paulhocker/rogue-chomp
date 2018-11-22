"""
	Draw a Maze on a Tilemap
	
	
"""
extends Node2D


onready var tile_map = $TileMap
onready var root = $Root

var walltops = []
var wallbots = []
var walllefts = []
var wallrights = []
var floors = []
var maze = []
var width
var height


func build(width, height, maze):
	"""
		Give a Width, Height and List of Data, draw
		a Maze on a TileMap
	"""
	
	self.maze = maze
	self.width = width
	self.height = height
	
	var tile_set = tile_map.tile_set
	
	var walltopleft = tile_set.find_tile_by_name('walltopleft_0')
	var walltopright = tile_set.find_tile_by_name('walltopright_0')
	var wallbotleft = tile_set.find_tile_by_name('wallbotleft_0')	
	var wallbotright = tile_set.find_tile_by_name('wallbotright_0')
	
	for i in range(12):
		floors.append(tile_set.find_tile_by_name('floor_%s' % i))
	
	for i in range(7):
		walltops.append(tile_set.find_tile_by_name('walltop_%s' % i))
	
	for i in range(7):
		wallbots.append(tile_set.find_tile_by_name('wallbot_%s' % i))
	
	for i in range(7):
		walllefts.append(tile_set.find_tile_by_name('wallleft_%s' % i))
	
	for i in range(7):
		wallrights.append(tile_set.find_tile_by_name('wallright_%s' % i))
	
	for x in range(width):
		var pos1 = Vector2(x + 2,1)
		tile_map.set_cellv(pos1, random_choice(walltops))
		var pos2 = Vector2(x + 2, height + 2)
		tile_map.set_cellv(pos2, random_choice(wallbots))
		
	for y in range(height + 1):
		var pos1 = Vector2(1, y + 2)
		tile_map.set_cellv(pos1, random_choice(walllefts))
		var pos2 = Vector2(width + 2, y + 2)
		tile_map.set_cellv(pos2, random_choice(wallrights))

	tile_map.set_cellv(Vector2(1,1), walltopleft)
	tile_map.set_cellv(Vector2(width + 2, 1), walltopright)
	tile_map.set_cellv(Vector2(1, height + 2), wallbotleft)
	tile_map.set_cellv(Vector2(width + 2, height + 2), wallbotright)
	
	for y in range(height):
		for x in range(width):
			var pos = Vector2(x+2, y+2)
			var tile = get_tile_at_position(x, y)
			var tile_num = -1
			
			if tile == '.':
				tile_num = random_choice(floors)
				var poso = Vector2((x+2.5)*16, (y+2.5)*16)
				var dot = Resources.Dot.instance()
				dot.position = poso
				root.add_child(dot)
				
			if tile == '|':
				
				if has_floor_left(x, y) and not has_floor_right(x, y):
					tile_num = random_choice(wallrights)
				
				if has_floor_right(x, y) and not has_floor_left(x, y):
					tile_num = random_choice(walllefts)
				
				if has_floor_above(x, y) and not has_floor_below(x, y):
					tile_num = random_choice(wallbots)
					
				if has_floor_below(x, y) and not has_floor_above(x, y):
					tile_num = random_choice(walltops)
					
			if tile_num >= 0:
				tile_map.set_cellv(pos, tile_num)
	
func has_floor_above(x, y):
	
	var index = get_tile_index(x, y)
	index -= width
	
	if index < 0:
		return false
		
	if maze[index] == '.':
		return true
		
	return false
	
func has_floor_below(x, y):
	var index = get_tile_index(x, y)
	index += width
	
	if index > maze.size():
		return false
		
	if maze[index] == '.':
		return true
		
	return false
	
func has_floor_left(x, y):
	var index = get_tile_index(x, y)
	index -= 1
	
	if index < 0:
		return false
		
	if maze[index] == '.':
		return true
		
	return false
	
	
func has_floor_right(x, y):
	var index = get_tile_index(x, y)
	index += 1
	
	if index > maze.size():
		return false
		
	if maze[index] == '.':
		return true
		
	return false

func get_tile_index(x, y):
	return x + (y * width)
	
	
func get_tile_at_position(x, y):
	return maze[get_tile_index(x, y)]
	
func random_choice(list):
	return list[randi()%list.size()]


func _ready():
	pass


func _init():
	pass	