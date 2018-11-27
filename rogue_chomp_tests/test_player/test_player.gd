extends Node2D

onready var player = $Player
onready var test_maze = $TestMazeGenerator

func _ready():
	player.set_maze(test_maze)
	player.jump_to_point(Vector2(0, 0))