extends Node2D

onready var player = $Player
onready var test_maze = $TestMazeGenerator
onready var state = $"CanvasLayer/$STATE"


func _process(delta):
	state.text = str(player.state)
	
	
func _ready():
	player.set_maze(test_maze.get_maze())
	player.jump_to_point(Vector2(0, 0))
	Logger.set_logger_level(Logger.LEVEL_WARN)	
