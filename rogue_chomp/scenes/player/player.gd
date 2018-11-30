extends KinematicBody2D


export (int) var SPEED = 50

enum {
	STATE_NONE,
	STATE_IDLE,
	STATE_MOVING,
	STATE_DEAD
}


const dir_left = Vector2(-1, 0)
const dir_right = Vector2(1, 0)
const dir_up = Vector2(0, -1)
const dir_down = Vector2(0, 1)
const dir_none = Vector2(0, 0)
const CELL_SIZE = 16
var ARRIVE_DISTANCE = 1


var move_dir
var new_dir
var curr_point
var target_point
var target_pos
var state
var maze

var last_target
var next_target
var half_adjust

func on_idle():
	Logger.trace("player.on_idle")
	
	var dir
	
	if Input.is_action_pressed("player_left"):
		dir = dir_left	
		
	if Input.is_action_pressed("player_right"):
		dir = dir_right	
		
	if Input.is_action_pressed("player_up"):
		dir = dir_up
		
	if Input.is_action_pressed("player_down"):
		dir = dir_down	
		
	if dir:
		new_dir = dir
	
	if not new_dir:
		return
	
	#	has a new direction
	if new_dir:
		#	and the cell in that direction is open
		if _is_point_open(curr_point, new_dir):
			#	start moving the player to the next cell
			change_state(STATE_MOVING)
			target_pos = _point_to_world(curr_point + new_dir)
			target_point = curr_point + new_dir
			move_dir = new_dir
			new_dir = dir_none
			
	new_dir = null
	
	
func on_moving():
	Logger.trace("player.on_moving")
	
	var velocity = move_dir.normalized() * SPEED * get_process_delta_time()
	#var velocity = (target_pos - position).normalized() * SPEED * get_process_delta_time()
	position += velocity
	
	var dis = position.distance_to(target_pos)
	var arrived = dis < ARRIVE_DISTANCE

	if arrived:
		position = target_pos
		change_state(STATE_IDLE)
		move_dir = dir_none
		curr_point = target_point
		target_pos = null
		target_point = null
			
	
func on_dead():
	Logger.trace("player.on_dead")
	
	
func on_none():
	Logger.trace("player.on_none")
	change_state(STATE_IDLE)
	
	
func set_maze(maze):
	self.maze = maze.maze
	

# move player to position on world 
func jump_to_point(point):
	Logger.trace("player.jump_to_point")
	curr_point = point
	position = _point_to_world(point)
	
	
func change_state(state):
	Logger.trace("player.change_state")
	self.state = state
	
	
func _point_to_world(point):
	Logger.trace("player._point_to_world")
	if _is_floor(point):
		return point * CELL_SIZE + half_adjust
	else:
		return Vector2(0, 0) + half_adjust
		
		
func _world_to_point(world_position):
	Logger.trace("player._world_to_point")
	var x = (world_position.x / CELL_SIZE)
	var y = (world_position.y / CELL_SIZE)
	var point = Vector2(x, y)
	return point.floor()
		
	
func _is_floor(point):
	Logger.trace("player._is_floor")
	if _get_cell_at_point(point) == ".":
		return true
	return false
	
	
func _process(delta):
	
	match state:
		
		STATE_NONE:
			on_none()
			
		STATE_IDLE:
			on_idle()
			
		STATE_MOVING:
			on_moving()
			
		STATE_DEAD:
			on_dead()
			

# look ahead from a position in the
# direction we are moving to see if the next
# location is a open (floor)
func _look_ahead_open(pos, dir):
	Logger.trace("player._look_ahead_open")
	var loc = pos + (dir * CELL_SIZE)
	if _is_floor(_world_to_point(loc)):
		return true
	return false


#	is the point in a direction open?
func _is_point_open(point, dir):
	Logger.trace("player._is_point_open")
	var loc = point + dir
	if _is_floor(loc):
		return true
	return false
	

func _get_cell_at_point(point):
	Logger.trace("player._get_cell_at_point")
	if point.x >= 0 and point.y >=0 and point.x < maze.width and point.y < maze.height:
		var index = point.x + point.y * maze.width
		var cell = maze.maze[index]
		Logger.trace("point: %s index:%s cell:%s" % [point, index, cell])
		return cell
	
	
func _ready():
	Logger.trace("player._ready")
	half_adjust = Vector2(1, 1) * (CELL_SIZE / 2)
	
	
func _init():
	Logger.trace("player._init")
	change_state(STATE_NONE)
	