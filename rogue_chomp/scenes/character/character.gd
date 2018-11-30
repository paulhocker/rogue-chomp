extends KinematicBody2D

#	size of grid in pixels
export var CELL_SIZE = 16

#	my speed
export var SPEED = 10

#	states
enum {
	STATE_NONE,
	STATE_IDLE,
	STATE_CHASE,
	STATE_THINK,
	STATE_SCATTER,
	STATE_SCARED,
	STATE_DEAD
}

#	character current state
var state = STATE_NONE

#	where we need to be
var target_pos

#	ending point on the tilemap
var end_point

#	tilemap nodes we are moving to
var nodes = []

#	the maze
var maze

#	debug mode true/false
var debug

var half_adjust

const BASE_LINE_WIDTH = 1.0
const DRAW_COLOR = Color('#fff')
var ARRIVE_DISTANCE = SPEED * 0.25
var MASS = 10.0


func on_idle():
	pass
		
	
func on_think():
	change_state(STATE_IDLE)
	if len(nodes) > 0:
		change_state(STATE_CHASE)
	
	
func on_chase():
	var vel = (target_pos - position).normalized() * SPEED * get_process_delta_time()
	var dis = position.distance_to(target_pos) 
	var arrived = dis < ARRIVE_DISTANCE
	position += vel
	
	if arrived: 
		nodes.remove(0)
		
		if len(nodes) == 0:
			position = target_pos
			on_last_point()
			return
		
		on_next_point(nodes[0])	
		target_pos = Vector2(nodes[0].x, nodes[0].y) * CELL_SIZE + half_adjust

		
func on_dead():
	change_state(STATE_NONE)


func on_scatter():
	change_state(STATE_IDLE)
	

func on_scared():
	change_state(STATE_IDLE)
	
	
func on_last_point():
	change_state(STATE_THINK)
	

func on_next_point(point):
	Logger.info("- point: %s" % [point])
	change_state(STATE_THINK)


func change_state(state):
	Logger.trace("character.change_state")
	self.state = state
	Logger.info("- state: %s" % [get_state_str()])
	

func get_end_point():
	return end_point
	
	
func get_state():
	return state
	
			
func get_state_str():
	var states = [
		"none",
		"idle",
		"chase",
		"think",
		"scatter",
		"scared",
		"dead"
	]
	
	return states[state]
	
	
func get_target_pos():
	return "%s" % [target_pos]
	
	
func get_path_nodes():
	return nodes
	
	
func set_maze(maze):
	self.maze = maze


#func set_tilemap(tilemap):
#	self.tilemap = tilemap

	
#	jump to a point on the tilemap
func jump_to_point(point):
	Logger.trace("character.jump_to_point")
	state = STATE_IDLE
	#position = tilemap.map_to_world(point) + (Vector2(1, 1) * (CELL_SIZE / 2.0))
	position = _point_to_world(point)
#	set_end_point(point)

	
func _world_to_point(world_position):
	Logger.trace("player._world_to_point")
	var x = (world_position.x / CELL_SIZE)
	var y = (world_position.y / CELL_SIZE)
	var point = Vector2(x, y)
	return point.floor()

func _point_to_world(point):
	Logger.trace("player._point_to_world")
	if _is_floor(point):
		return point * CELL_SIZE + half_adjust
	else:
		return Vector2(0, 0) + half_adjust
		
func _is_floor(point):
	Logger.trace("player._is_floor")
	if _get_cell_at_point(point) == ".":
		return true
	return false
	
func _get_cell_at_point(point):
	Logger.trace("player._get_cell_at_point")
	if point.x >= 0 and point.y >=0 and point.x < maze.width and point.y < maze.height:
		var index = point.x + point.y * maze.width
		var cell = maze.tiles[index]
		Logger.trace("point: %s index:%s cell:%s" % [point, index, cell])
		return cell

#	set the point to move to - recalculates path
func set_end_point(end_point):
	Logger.trace("character.set_path_nodes")
	Logger.info("end_point:%s" % [end_point])
	
	state = STATE_IDLE
	self.end_point = end_point
	
	var start_point = _world_to_point(position)
	
	nodes = _calculate_path(start_point, end_point)
		
	if not nodes or len(nodes) == 1:
		return
		
	Logger.info("nodes: %s" % [nodes])
	target_pos = Vector2(nodes[1].x, nodes[1].y) * CELL_SIZE + (Vector2(1, 1) * (CELL_SIZE / 2.0))
	
	state = STATE_CHASE

	
func _calculate_path(start_pos, end_pos):
	Logger.trace("character._calculate_path")
	
	#	if no end point - set to start point
	if end_pos == null:
		end_pos = start_pos
			
	var nodes = maze.get_path(start_pos, end_pos)
	return nodes


func _ready():
	Logger.trace("character._ready")
	half_adjust = Vector2(1, 1) * (CELL_SIZE / 2)
	
func _init():
	Logger.trace("character._init")
	state = STATE_NONE
	
	
func _process(delta):
	
	
	match state:
		
		STATE_IDLE:
			on_idle()
			
		STATE_CHASE:
			on_chase()

		STATE_THINK:
			on_think()
			
		STATE_SCARED:
			on_scared()
			
		STATE_SCATTER:
			on_scatter()