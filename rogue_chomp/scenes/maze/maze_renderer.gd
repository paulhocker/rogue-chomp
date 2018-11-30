"""
	Script: Render a Maze in the Scene
"""

extends Node2D

var width
var height
var maze

#export (Resource) var tileset


"""
	Method: Render the Maze
"""
func render(width, height, maze): 
	Logger.trace('maze_renderer.render')
	self.width = width
	self.height = height
	self.maze = maze

func _get_tile_index(x, y):
	return x + (y * width)
	
	
func _get_tile_at_position(x, y):
	return maze[_get_tile_index(x, y)]
	

func _init():
	Logger.trace('maze_renderer._init')
	pass