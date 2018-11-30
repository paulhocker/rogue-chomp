extends KinematicBody2D


enum item_types {
	ITEM_TYPE_NONE,
	ITEM_TYPE_WEAPON,
	ITEM_TYPE_ARMOR,
	ITEM_TYPE_TREASURE,
	ITEM_TYPE_CHEST,
	ITEM_TYPE_KEY,
	ITEM_TYPE_SCROLL,
	ITEM_TYPE_POTION
}


# name of the item
export (String) var item_name = "None"
# type of item
export (item_types) var item_type = ITEM_TYPE_NONE
# value of the item ni gold
export (int) var item_value = 0
# how long will the item be available when found
export (int) var item_life = 0
# xp collected
export (int) var item_xp = 0

var id



# what to do when i enter the scene
func on_enter():
	pass

	
# what to do when opened
func on_open():
	pass

	
# what to do when closed
func on_close():
	pass


# what to do when the player picks me up
func on_pickup():
	pass

	
# what to do when the player uses me	
func on_use():
	pass

	
# what to do this frame - helper function for process
func on_process(delta):
	pass

		
# what to do when dropped
func on_drop():
	pass
	
	
func _process(delta):
	on_process(delta)
	
	
func _ready():
	pass


func _init():
	id = Resources.UUID.new()
	