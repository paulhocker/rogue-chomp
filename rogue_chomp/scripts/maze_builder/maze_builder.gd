extends "../thing.gd"

const maze_wall = '|'
const maze_floor = '.'

var maze
var tiles
var w
var h
var dirs = [ Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0) ]
var verbose = false
var pos_list
var connections

func build():
	Logger.trace('maze_builder:build')
	var tt = _create()
	maze = []
	for y in range(h):
		for x in range(w-2):
			var i = x+(y*w)
			maze.append(tt[i])
		for x in range(w-2):
			var i = (w-3-x)+(y*w)
			maze.append(tt[i])
	
	print(maze)
	return maze
		
func _create():
	Logger.trace('maze_builder:_create')
	while add_wall_obstacle(null, null, true):
		pass
	return tiles


func all(iter):
	for e in iter:
		if not e:
			return false
	return true


func any(iter):
	for e in iter:
		if not e:
			return false
	return true


func format_map_string(tile_str, sep):
	var lines = tile_str.strip_edges().split('\n')
	var sl = []
	for line in lines:
		sl.append(line.strip_edges())
	var spa = PoolStringArray(sl)
	var spl = spa.join(sep)
	var ret = []
	print(spl)
	for l in spl:
		ret.append(l)
	return ret


func __init__(w, h, tile_str=null):
	
	if not tile_str:
		self.tiles = []
		self.w = w
		self.h = h
		for i in range(w*h):
			self.tiles.append(maze_floor)
	else:
		self.set_map(w, h, tile_str)
		
	self.verbose = false
	
	
func set_map(w, h, tile_str):
	self.w = w
	self.h = h
	self.tiles = format_map_string(tile_str, "")
	
	
func __str__():
	var s = '\n'
	var i = 0
	for y in range(self.h):
		for x in range(self.w):
			s += tiles[i]
			i += 1
		s += '\n'
	return s
	

func xy_valid(x, y):
	return x >= 0 and x < self.w and y >= 0 and y < self.h
	
	
func get_tile(x, y):
	if not xy_valid(x, y):
		return null
	return self.tiles[x+y*self.w]
	
	
func add_wall_tile(x, y):
	if xy_valid(x, y):
		self.tiles[x+y*self.w] = maze_wall
		
		
func is_wall_block_filled(x, y):
	var ret = false
	for dy in range(1,3):
		for dx in range(1,3):
			if get_tile(x+dx, y+dy) == maze_wall:
				ret = true
	return ret
	


func add_wall_block(x, y):
	add_wall_tile(x+1,y+1)
	add_wall_tile(x+2,y+1)
	add_wall_tile(x+1,y+2)
	add_wall_tile(x+2,y+2)


func can_new_block_fit(x, y):
	if not (xy_valid(x,y) and xy_valid(x+3,y+3)):
		return false
	for y0 in range(y,y+4):
		for x0 in range(x,x+4):
			if get_tile(x0,y0) != '.':
				return false
	return true
	


func update_pos_list():
	pos_list = []
	for y in range(self.h):
		for x in range(self.w):
			if self.can_new_block_fit(x,y):
				self.pos_list.append(Vector2(x,y))


func update_connections():
	connections = {}
	for y in range(self.h):
		for x in range(self.w):
			
			if Vector2(x,y) in self.pos_list:
				
				var add
				
				add = false
				
				for y0 in range(4):
					if (get_tile(x-1, y+y0)) == maze_wall:
						add = true	
						
				if add:
					add_connection(x, y, 1, 0)
					
				add = false
				
				for y0 in range(4):
					if (get_tile(x+4, y+y0)) == maze_wall:
						add = true	
						
				if add:
					add_connection(x, y, -1, 0)
					
				add = false
				
				for x0 in range(4):
					if (get_tile(x+x0, y-1)) == maze_wall:
						add = true	
						
				if add:
					add_connection(x, y, 0, 1)
					
				add = false
				
				for x0 in range(4):
					if (get_tile(x+x0, y+4)) == maze_wall:
						add = true	
						
				if add:
					add_connection(x, y, 0, -1)
					
	
func add_connection(x, y, dx, dy):
	if Vector2(x, y) in self.pos_list:
		connect(x, y, x+dx, y+dy)
		connect(x, y, x+2*dx, y+2*dy)
		if not Vector2(x-dy,y-dx) in self.pos_list: connect(x, y, x+dx-dy,y+dy-dx)
		if not Vector2(x+dy,y+dx) in self.pos_list: connect(x, y, x+dx+dy,y+dy+dx)
		if not Vector2(x+dx-dy,y+dy-dx) in self.pos_list: connect(x, y, x+2*dx-dy, y+2*dy-dx)
		if not Vector2(x+dx+dy,y+dy+dx) in self.pos_list: connect(x, y, x+2*dx+dy, y+2*dy+dx)
			
			
		
func connect(x, y, x0, y0):
	var src = Vector2(x, y)
	var dest = Vector2(x0, y0)
	if not dest in self.pos_list:
		return
	if dest in self.connections:
		self.connections[dest].append(src)
	else:
		self.connections[dest] = [src]
		
		
func update():
	update_pos_list()
	update_connections()
	
	
func expand_wall(x, y):
	var visited = []
	return expand(x, y, visited)
	
	
func expand(x, y, visited):
	var count = 0
	var src = Vector2(x, y)
	if src in visited:
		return 0
	visited.append(src)
	if src in self.connections:
		for vec2 in self.connections[src]:
			var tf = is_wall_block_filled(vec2.x, vec2.y)
			if not tf:
				count += 1
				add_wall_block(vec2.x, vec2.y)
			count += expand(vec2.x, vec2.y, visited)
	return count
	
	
func get_most_open_dir(x, y):
	pass
	
	
func add_wall_obstacle(x=null, y=null, extend=false):
	
	update()
	if not self.pos_list:
		return false
	
	if (x == null or y == null):
		var pos = random_choice(self.pos_list)
		x = pos.x
		y = pos.y
		
	add_wall_block(x, y)
		
	var fl = __str__().split('\n')
	var gl = []
	var el = []
	for i in range(self.h+2):
		gl.append("")
		el.append("")
		
	var count = expand_wall(x, y)
	if count > 0:
		gl = __str__().split('\n')
		
	if extend:
		
		var mb = 4
		
		var turn = false
		var tb = mb
		if 	randf() < 0.35:
			tb = 4
			mb += tb
			
		var dir = random_choice(dirs)
		var odir = dir
		
		var i = 0
		while count < mb:
			var x0 = x + dir.x * i
			var y0 = y + dir.y * i
			
			if (not turn and count >= tb) or not (Vector2(x0, y0) in self.pos_list):
				turn = true
				dir = Vector2(-dir.y, dir.x)
				i = 1
				if odir == dir: break
				else: continue
				
			if not is_wall_block_filled(x0, y0):
				add_wall_block(x0, y0)
				count += 1 + expand_wall(x0, y0)
			
			i += 1
			
		el = __str__().split('\n')
		
	if verbose:
		print('added block at %s, %s' % [x, y] )
		var i = 0
		for l in fl:
			print("%s %s %s" % [l, gl[i], el[i]])
			i += 1
		
	return true
			

func random_choice(list):
	return list[randi()%list.size()]
	
	
func _ready():
	Logger.trace('maze_builder:_ready')
	pass
	
	
func _init():
	Logger.trace('maze_builder:_init')
	pass
	