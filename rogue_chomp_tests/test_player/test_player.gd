extends Node2D

onready var player = $Player
onready var test_maze = $TestMazeGenerator
onready var debug_text = $"CanvasLayer/$DEBUG"


func _process(delta):
	debug_text.text = "%s:%s:%s" % [ player.get_state_str(), player.get_target_point(), player.get_target_position()]
	
	
func _ready():
	player.set_maze(test_maze.maze)
	player.jump_to_point(Vector2(0, 0))
	Logger.set_logger_level(Logger.LEVEL_WARN)	
