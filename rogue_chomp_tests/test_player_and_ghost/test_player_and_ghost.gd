extends Node

onready var player = $Player
onready var ghost = $Ghost
onready var test_maze = $TestMazeGenerator
	
	
func _ready():
	Logger.set_logger_level(Logger.LEVEL_WARN)	
	player.set_maze(test_maze)
	player.jump_to_point(Vector2(0, 0))
	ghost.set_maze(test_maze)
	ghost.jump_to_point(Vector2(15, 0))
