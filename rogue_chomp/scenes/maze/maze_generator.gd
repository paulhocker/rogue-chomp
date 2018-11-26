"""
	Class: Interface to Build a Maze
	
	Remarks:
			
		A Maze is represented as a string of
		Characters that either represent a
		Wall or a Floor tile.	
"""
extends "res://rogue_chomp/scripts/thing.gd"

const maze_wall = '|'
const maze_floor = '.'


func build(width, height, maze):
	"""
		Method: Returns a Series of Characters Representing a Maze
		
		Remarks:
		s
	"""
	return maze
	
	
func _ready():
	Logger.trace('maze_generator._ready')
	
	
func _init():
	Logger.trace('maze_generator._init')
	