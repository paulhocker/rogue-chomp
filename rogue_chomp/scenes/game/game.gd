extends Node

onready var Player = Resources.Player
onready var Maze = Resources.Maze

var player


func _ready():
	player = Player.instance()
	add_child(player)
	pass