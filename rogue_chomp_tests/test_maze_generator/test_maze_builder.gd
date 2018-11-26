extends Node2D


onready var MazeBuilder = Resources.MazeBuilder
onready var Dot = Resources.Dot
onready var TestTile = load("res://rogue_chomp_tests/test_tile.tscn")
onready var TestWall = load("res://rogue_chomp_tests/test_wall.tscn")
onready var root = $Root

var width = 10
var height = 25
var maze_width = (width - 2) * 2
var maze

func _init():
	randomize()
	pass


func _ready():
	#_ready0()
	_ready1()
	#_ready2()


func _ready0():
	Logger.trace('test_maze_builder:_ready0')
	assert(get_tile_index(0,0) == 0)
	assert(get_tile_index(1,0) == 1)
	assert(get_tile_index(1,1) == 12)


func _ready1():
	Logger.trace('test_maze_builder:_ready')
	var mb = MazeBuilder.new()
	mb.__init__(width, height, null)
	maze = mb.build()
	print_maze(width, height, maze)
	#sprite_maze((width-2)*2, height, maze)
	tilemap_maze((width-2)*2, height, maze)


func _ready2():
	Logger.trace('test_maze_builder:_ready')
	var mb = MazeBuilder.new()
	mb.__init__(16, 42,"""
        ||||||||||||||||
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        |...............
        ||||||||||||||||
	""")
	var maze = mb.build()
	print_maze(16, 42, maze)
	tile_maze(28, 42, maze)


func print_maze(w, h, maze):
	var i = 0
	for y in range(h):
		for x in range((w-2)*2):
			printraw(maze[i])
			i += 1
		print()

# draw maze using sprites
func sprite_maze(w, h, maze):
	var tile_size = 8
	for x in w:
		for y in h:
			var px = x * tile_size
			var py = y * tile_size
			var pos = Vector2(px, py)
			var tile
			if maze[x + y * w] == '.':
				tile = TestTile.instance()
			else:
				tile = TestWall.instance()
			tile.position = pos
			root.add_child(tile)
	
# draw maze using tilemap
func tilemap_maze(w, h, maze):
	
	var tm = $Root/TileMaze
	var to = $Root/TileMapObjects
	var ts = tm.tile_set
	var tso = to.tile_set
	
	var walltops = []
	var wallbots = []
	var walllefts = []
	var wallrights = []
	var floors = []
	
	var walltopleft = ts.find_tile_by_name('walltopleft_0')
	var walltopright = ts.find_tile_by_name('walltopright_0')
	var wallbotleft = ts.find_tile_by_name('wallbotleft_0')	
	var wallbotright = ts.find_tile_by_name('wallbotright_0')
	
	for i in range(12):
		floors.append(ts.find_tile_by_name('floor_%s' % i))
	
	for i in range(7):
		walltops.append(ts.find_tile_by_name('walltop_%s' % i))
	
	for i in range(7):
		wallbots.append(ts.find_tile_by_name('wallbot_%s' % i))
	
	for i in range(7):
		walllefts.append(ts.find_tile_by_name('wallleft_%s' % i))
	
	for i in range(7):
		wallrights.append(ts.find_tile_by_name('wallright_%s' % i))
	
	for x in range(w):
		var pos1 = Vector2(x+2,1)
		tm.set_cellv(pos1, random_choice(walltops))
		var pos2 = Vector2(x+2,h+2)
		tm.set_cellv(pos2, random_choice(wallbots))
		
	for y in range(h+1):
		var pos1 = Vector2(1,y+2)
		tm.set_cellv(pos1, random_choice(walllefts))
		var pos2 = Vector2(w+2,y+2)
		tm.set_cellv(pos2, random_choice(wallrights))

	tm.set_cellv(Vector2(1,1), walltopleft)
	tm.set_cellv(Vector2(w+2,1), walltopright)
	tm.set_cellv(Vector2(1,h+2), wallbotleft)
	tm.set_cellv(Vector2(w+2,h+2), wallbotright)
	
	for y in range(h):
		for x in range(w):
			var pos = Vector2(x+2, y+2)
			var tile = get_tile_at_position(x, y)
			var tile_num = -1
			
			if tile == '.':
				tile_num = random_choice(floors)
				var poso = Vector2((x+2.5)*16, (y+2.5)*16)
				var dot = Dot.instance()
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
				tm.set_cellv(pos, tile_num)
	
func random_choice(list):
	return list[randi()%list.size()]

func has_floor_above(x, y):
	
	var index = get_tile_index(x, y)
	index -= maze_width
	
	if index < 0:
		return false
		
	if maze[index] == '.':
		return true
		
	return false
	
func has_floor_below(x, y):
	var index = get_tile_index(x, y)
	index += maze_width
	
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
	return x + (y * maze_width)
	
func get_tile_at_position(x, y):
	return maze[get_tile_index(x, y)]