"""
	Class: Represents a Maze in the Game
	
	Remarks:
		
		This provides an Object to the Developer that can
		be used to interact with the Maze of the game.
	
"""
extends Node2D


export (int) var width = 20
export (int) var height = 20
export (Resource) var maze_generator
export (Resource) var maze_renderer


var astar

var tiles
var renderer 
var generator
var maze_size

var path_start_position
var path_end_position

var point_path = []
var walkable_tiles = []


func build(width, height, tiles):
	Logger.trace("maze.build")
	"""
		Function: Build Maze
		
		Remarks:
			
			The Starting Maze mus be a string of
			Characters.
			
			It can be delimited by a linefeed (\n)
			character. 
			
			Only valid characters will be accepted,
			any other character will be interpreted
			as a wall
			
		
		Parameters:
			
			width	desired width of the maze
			height	desired height of the maze
			maze	a starting maze
			
	"""
	randomize()
	
	self.tiles = null
		
	if width:
		self.width = width
		
	if height:
		self.height = height
		
	if tiles:
		self.tiles = tiles
		
	maze_size = Vector2(self.width, self.height)
		
	self.tiles = generator.build(self.width, self.height, self.tiles)
	
	walkable_tiles = _astar_add_cells()
	_astar_connect_cells(walkable_tiles)
	

func render():
	Logger.trace("maze.render")
	renderer.render(self)
	

func get_path(world_start, world_end):
	Logger.trace("maze.get_path")
	path_start_position =  world_start
	path_end_position = world_end	
	_calculate_path()
	return point_path
	
func set_generator(generator):
	self.generator = generator
	
func set_renderer(renderer):
	#if self.renderer:
	#	remove_child(self.renderer)
		
	self.renderer = renderer
	#add_child(self.renderer)
	
func get_open_tiles():
	return walkable_tiles
	
func get_astar_points():
	return astar.get_points()
	
func get_astar_positions():
	var point_positions = []
	for point in astar.get_points():
		point_positions.append(astar.get_point_position(point))
	return point_positions
	
func _astar_add_cells():
	Logger.trace("maze._astar_add_cells")
	astar.clear()
	var points_array = []
	for y in range(height):
		for x in range(width):
			var point = Vector2(x, y)
			var point_index = _calculate_point_index(point)
			if tiles[point_index] == "|":
				continue
			points_array.append(point)
			astar.add_point(point_index, Vector3(point.x, point.y, 0))
	return points_array
	

func _astar_connect_cells(points):
	Logger.trace("maze._astar_connect_cells")
	for point in points:
		var point_index = _calculate_point_index(point)
		var points_relative = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1)])
		for point_relative in points_relative:
			var point_relative_index = _calculate_point_index(point_relative)
			
			if _is_outside_bounds(point_relative):
				continue
				
			if not astar.has_point(point_relative_index):
				continue
				
			astar.connect_points(point_index, point_relative_index, false)


func _calculate_point_index(point):
	return point.x + (point.y * maze_size.x)


func _is_outside_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= maze_size.x or point.y >= maze_size.y
	
	
func _calculate_path():
	var start_point_index = _calculate_point_index(path_start_position)
	var end_point_index = _calculate_point_index(path_end_position)
	point_path = astar.get_point_path(start_point_index, end_point_index)
	
func _ready():
	Logger.trace("maze._ready")
	
	
func _init():
	Logger.trace("maze._init")
	astar = AStar.new()
	
	if not maze_renderer:
		renderer = Resources.GridMazeRenderer.instance()
	else:
		renderer = maze_renderer.instance()

	if renderer:	
		add_child(renderer)
	else:
		Logger.error("Invalid Renderer")
		get_tree().quit()
		
	if not maze_generator:
		generator = Resources.SimpleMazeGenerator.new()
	else:
		generator = maze_generator.new()
	
	