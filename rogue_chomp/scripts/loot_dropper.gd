"""
	Class: Loot Dropper
	
	Remarks:
		
		
"""

extends "./thing.gd"

var items = []

var has_items = false setget , _get_has_items



func pull():
	var index = randi()%items.size()
	var item = items[index]
	items.remove(index)
	return item
	
	
func fill(items):
	self.items = items

	
func add(item):
	items.append(item)
	
	
func random_choice(list):
	return items[randi()%items.size()]


func _get_has_items():
	return items.size() > 0


func _ready():
	pass


func _init():
	pass