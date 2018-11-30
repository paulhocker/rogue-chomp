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
func render(maze): 
	Logger.trace('maze_renderer.render')
	self.width = maze.width
	self.height = maze.height
	self.maze = maze

func get_tile_index(x, y):
	return x + (y * width)
	
	
func get_tile_at_position(x, y):
	return maze.tiles[get_tile_index(x, y)]
	

func _init():
	Logger.trace('maze_renderer._init')
	pass