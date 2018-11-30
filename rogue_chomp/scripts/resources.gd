
extends Node

const UUID = preload("uuid.gd")
const Thing = preload("thing.gd")

# maze generators
const SimpleMazeGenerator = preload("res://rogue_chomp/scenes/maze/simple_maze_generator.gd")

# maze renderers
const ConsoleMazeRenderer = preload("res://rogue_chomp/scenes/maze/console_maze_renderer.tscn")
const GridMazeRenderer = preload("res://rogue_chomp/scenes/maze/grid_maze_renderer.tscn")

const Player = preload("res://rogue_chomp/scenes/player/player.tscn")
const Dot = preload("res://rogue_chomp/scenes/dot/dot.tscn")
const Path = preload("res://rogue_chomp/scenes/path/path.tscn")
const Maze = preload("res://rogue_chomp/scenes/maze/maze.tscn")

# items
const Coin = preload("res://rogue_chomp/scenes/items/coin.tscn")
const SilverChest = preload("res://rogue_chomp/scenes/items/silver_chest.tscn")
const SilverKey = preload("res://rogue_chomp/scenes/items/silver_key.tscn")
