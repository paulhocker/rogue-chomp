extends KinematicBody2D


export (int) var SPEED = 50


const dir_left = Vector2(-1, 0)
const dir_right = Vector2(1, 0)
const dir_up = Vector2(0, -1)
const dir_down = Vector2(0, 1)
const dir_none = Vector2(0, 0)
const CELL_SIZE = 16


var last_dir = dir_right
var maze
var last_target
var next_target
var half_adjust

func set_maze(maze):
	self.maze = maze.maze
	

# move player to position on world 
func jump_to_point(point):
	Logger.trace("player.jump_to_point")
	position = _point_to_world(point)
	
	
func _point_to_world(point):
	if _is_floor(point):
		return point * 16 + half_adjust
	else:
		return Vector2(0, 0) + half_adjust
		
		
func _world_to_point(world_position):
	var x = (world_position.x / CELL_SIZE)
	var y = (world_position.y / CELL_SIZE)
	var point = Vector2(x, y)
	return point.floor()
		
	
func _is_floor(point):
	if point.x >= 0 and point.y >=0 and point.x < maze.width and point.y < maze.height:
		var index = point.x + point.y * maze.width
		var cell = maze.maze[index] # <--- wow, really?!?
		print("point: %s index:%s cell:%s" % [point, index, cell])
		if cell == ".":
			return true
	return false
	
	
func _process(delta):
	
	var dir = dir_none
	var cur_pos = position
	
	if Input.is_action_pressed("player_left"):
		dir = dir_left	
		
	if Input.is_action_pressed("player_right"):
		dir = dir_right	
		
	if Input.is_action_pressed("player_up"):
		dir = dir_up
		
	if Input.is_action_pressed("player_down"):
		dir = dir_down	
		
	var velocity = dir * SPEED * delta
	var next_pos = position + velocity
	
	if _look_ahead_open(next_pos, dir):
		position = next_pos


# look ahead from the current position in the
# direction we are moving to see if the next
# location is a open (floor)
func _look_ahead_open(next_position, dir):
	var loc = next_position + (dir * half_adjust)
	if _is_floor(_world_to_point(loc)):
		return true
	return false
	
	
func _ready():
	Logger.trace("player._ready")
	half_adjust = Vector2(1, 1) * (CELL_SIZE / 2)
	
func _init():
	Logger.trace("player._init")
	