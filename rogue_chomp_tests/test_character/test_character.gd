extends Node


onready var start_node = $TestStartNode
onready var end_node = $TestEndNode
onready var character = $Character
onready var test_maze = $TestMazeGenerator
onready var debug_text = $"CanvasLayer/VBoxContainer/$DEBUG"


var tilemap
var debug
var maze


const BASE_LINE_WIDTH = 1.0
const DRAW_COLOR = Color('#fff')


func _process(delta):
	
	maze = test_maze.get_maze()
	
	if not maze:
		return
	
	if Input.is_action_just_pressed("debug"):
		debug = !debug
	
	if debug:
		debug_text.text = "%s:%s:%s" % [character.get_state_str(), character.get_target_pos(), character.get_end_point()]
	
	var mouse_position = get_global_mouse_position()
	var location = tilemap.world_to_map(mouse_position)
	var cell = tilemap.get_cell(location.x, location.y)
	var c = ""
	var index = -1
	if location.x >=0 and location.y >=0 and location.x < maze.width and location.y < maze.height:	
		index = location.x + location.y * maze.width
		c = maze.tiles[index]
		
	if Input.is_action_just_pressed("game_drop_end_node"):
		
		if c == ".":
			character.maze = maze
			var pos = tilemap.map_to_world(location) + Vector2(8, 8)
			end_node.position = pos
			start_node.position = character.position
			character.set_end_point(location)
			var debug_path = character.get_path_nodes()
			
	update()

func _draw():
	
	var path_points = character.get_path_nodes()
		
	if not path_points:
		return
		
	#print(path_points)
		
	var point_start = path_points[0]
	var point_end = path_points[len(path_points) - 1]

	var last_point = tilemap.map_to_world(Vector2(point_start.x, point_start.y)) + Vector2(8, 8)
	for index in range(1, len(path_points)):
		var current_point = tilemap.map_to_world(Vector2(path_points[index].x, path_points[index].y)) + Vector2(8, 8)
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 3.0, DRAW_COLOR)
		last_point = current_point
	

func _ready():
	Logger.trace("test_character._ready")
	
	test_maze.build()
	maze = test_maze.get_maze()
	
	tilemap = get_tree().get_root().find_node("TileMap", true, false)
	var pos = tilemap.map_to_world(Vector2(0,0)) + Vector2(8, 8)
	
	start_node.position = pos
	end_node.position = pos
	
	character.set_maze(maze)
	#character.set_tilemap(tilemap)
	character.jump_to_point(Vector2(0,0))
	
func _init():
	Logger.set_logger_level(Logger.LEVEL_WARN)