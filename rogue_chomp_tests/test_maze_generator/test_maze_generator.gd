extends Node2D

onready var maze = $Maze
onready var start_node = $TestStartNode
onready var end_node = $TestEndNode
onready var character = $Character

var tilemap
var debug = false

const BASE_LINE_WIDTH = 1.0
const DRAW_COLOR = Color('#fff')

export (Vector2) var map_offset = Vector2(2, 3)

func _build():
	maze.build(null, null, null)
	maze.render()
	

func _draw():
	
	if not debug: return
		
	#	print all astar nodes
	#var pp = maze.get_astar_positions()
	#for pos in pp:
	#	var pos2 = Vector2(pos.x, pos.y) * 16 + Vector2(8, 8)
	#	draw_circle(pos2, BASE_LINE_WIDTH * 2, DRAW_COLOR)
	
	var path_points = character.get_path_nodes()
		
	if not path_points:
		return
		
	var point_start = path_points[0]
	var point_end = path_points[len(path_points) - 1]

	var last_point = tilemap.map_to_world(Vector2(point_start.x, point_start.y)) + Vector2(8, 8)
	for index in range(1, len(path_points)):
		var current_point = tilemap.map_to_world(Vector2(path_points[index].x, path_points[index].y)) + Vector2(8, 8)
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 3.0, DRAW_COLOR)
		last_point = current_point
	
	
func _process(delta):
	
	$"CanvasLayer/VBoxContainer/$STATE".text = character.get_state()
	$"CanvasLayer/VBoxContainer/$TARGET".text = character.get_target_pos()
	
	if Input.is_action_just_pressed("debug"):
		debug = !debug
	
	if Input.is_action_just_pressed("game_next_map"):
		_build()	
		
	if Input.is_action_just_pressed("game_drop_end_node"):
		
		var mouse_position = get_global_mouse_position()
		var location = tilemap.world_to_map(mouse_position)
		var cell = tilemap.get_cell(location.x, location.y)
		print(mouse_position, location, cell)
	
		if cell == 0:
			var pos = tilemap.map_to_world(location) + Vector2(8, 8)
			end_node.position = pos
			character.set_end_point(location)
			var debug_path = character.get_path_nodes()
			
	update()
				
		
func _ready():
	
	get_node("Camera2D").position -= map_offset * 16
	
	tilemap = get_tree().get_root().find_node("TileMap", true, false)
	
	_build()
	
	var pos = tilemap.map_to_world(Vector2(0,0)) + Vector2(8, 8)
	
	start_node.position = pos
	end_node.position = pos
	
	character.set_maze(maze)
	character.set_tilemap(tilemap)
	character.jump_to_point(Vector2(0,0))
	
