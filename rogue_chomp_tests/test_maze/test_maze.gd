extends Node


onready var Maze = $Maze

var maze1 = """
..........
.||||||.|.
........|.
.||||||||.
.||||.....
......|||.
.||||||||.
.|........
.|.||||||.
..........
"""

func str_to_array(maze):
	var lines = maze.strip_edges().split('\n')
	var st = maze.replace('\n', "")
	var ret = []
	for s in st:
		ret.append(s)
	return ret
	

func _ready():
	
	Maze.build(10, 10, str_to_array(maze1))
	
