extends "./maze_renderer.gd"

func render(maze): 
	Logger.trace('console_maze_renderer.render')
	.render(maze)
	for y in range(height):
		for x in range(width):
			printraw(maze.tiles[x + (y * (width))])
		print()

