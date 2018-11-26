extends "./maze_renderer.gd"


onready var tile_map = $TileMap
onready var tile_set = tile_map.tile_set


var walltops = []
var wallbots = []
var walllefts = []
var wallrights = []
var walltl = []
var walltr = []
var wallbl = []
var wallbr = []
var floors = []



func render(width, height, maze):
	"""
		Give a Width, Height and List of Data, draw
		a Maze on a TileMap
	"""
	
	self.maze = maze
	self.width = width
	self.height = height
	
	var tile_set = tile_map.tile_set
	
	"""
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
	"""
	
	var pos
	
	for x in range(width + 2):
		pos = Vector2(x-1, -1)
		tile_map.set_cellv(pos, random_choice(walltops))
		pos = Vector2(x-1, height)
		tile_map.set_cellv(pos, random_choice(wallbots))
		
	for y in range(height):
		pos = Vector2(-1, y)
		tile_map.set_cellv(pos, random_choice(walllefts))
		pos = Vector2(width, y)
		tile_map.set_cellv(pos, random_choice(wallrights))

	#tile_map.set_cellv(Vector2(1,1), random_choice(walltl))
	#tile_map.set_cellv(Vector2(width + 2, 1), random_choice(walltr))
	#tile_map.set_cellv(Vector2(1, height + 2), random_choice(wallbl))
	#tile_map.set_cellv(Vector2(width + 2, height + 2), random_choice(wallbr))
	
	for y in range(height):
		for x in range(width):
			pos = Vector2(x, y)
			var tile = get_tile_at_position(x, y)
			var tile_num = -1
			
			if tile == '.':
				tile_num = random_choice(floors)
				#var poso = Vector2((x+2.5)*16, (y+2.5)*16)
				#var dot = Resources.Dot.instance()
				#dot.position = poso
				#root.add_child(dot)
				
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


func str_to_array(maze):
	var lines = maze.strip_edges().split('\n')
	var st = maze.replace('\n', "")
	var ret = []
	for s in st:
		ret.append(s)
	return ret


func _ready():
	for tile in tile_set.get_tiles_ids():
		var tile_name = tile_set.tile_get_name(tile).split("_")
		
		match tile_name[0]:
			
			"walltop":
				walltops.append(tile)
				
			"wallbot":
				wallbots.append(tile)
				
			"wallleft":
				walllefts.append(tile)
				
			"wallright":
				wallrights.append(tile)
				
			"walltl":
				walltl.append(tile)
				
			"walltr":
				walltr.append(tile)
				
			"wallbl":
				wallbl.append(tile)
				
			"wallbr":
				wallbr.append(tile)
				
			"floor":
				floors.append(tile)
				