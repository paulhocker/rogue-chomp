extends KinematicBody2D

#	size of grid in pixels
export var grid_size = 8

#	my speed
export var speed = 10

#	where we are
var cur_pos	

#	where we are moving to
var next_pos

#	where we need to be
var target_pos


func _init():
	pass
	
func _process(delta):
	position += Vector2(1,0) * speed * delta
	
	
		
func _move_to(pos):
	next_pos = cur_pos
	