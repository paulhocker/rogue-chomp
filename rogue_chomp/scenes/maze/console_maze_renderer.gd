extends "./maze_renderer.gd"

func render(width, height, maze): 
	Logger.trace('console_maze_renderer.render')
	for y in range(height):
		for x in range(width):
			printraw(maze[x + (y * (width))])
		print()

