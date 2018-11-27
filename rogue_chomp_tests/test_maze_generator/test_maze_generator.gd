extends Node2D

onready var maze = $Maze

var tilemap
var debug = false

const BASE_LINE_WIDTH = 1.0
const DRAW_COLOR = Color('#fff')

export (Vector2) var map_offset = Vector2(2, 3)


func build():
	_build()
	
	
func get_maze():
	return maze
	
	
func _build():
	maze.build(null, null, null)
	maze.render()
	

func _draw():
	
	if not debug: return
		
	#	print all astar nodes
	var pp = maze.get_astar_positions()
	for pos in pp:
		var pos2 = Vector2(pos.x, pos.y) * 16 + Vector2(8, 8)
		draw_circle(pos2, BASE_LINE_WIDTH * 2, DRAW_COLOR)
	
	
func _process(delta):
	
	if Input.is_action_just_pressed("debug"):
		debug = !debug
	
	if Input.is_action_just_pressed("game_next_map"):
		_build()	
		
	update()
				
		
func _ready():
	Logger.trace("test_maze_generator._ready")
	get_node("Camera2D").position -= map_offset * 16
	tilemap = get_tree().get_root().find_node("TileMap", true, false)
	_build()
	
