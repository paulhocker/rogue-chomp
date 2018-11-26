"""
	A Thing is Something that exists in the Game

	@remarks
	A Thing is Nothing but it is Everything. For that
	reason, Everything in the Game must be a Thing.

	@copyright
	Copyright 2018, SpockerDotNet LLC
	
"""

extends Reference


var UUID = Resources.UUID


#	@type:uuid The Unique Identifier
var id = "" setget , _get_id
#	@type:bool Is this Thing Active
var is_active = true
#	@type:bool Is this Thing Visible
var is_visible = true


#	@PUBLIC


#	@PRIVATE


func _get_id():
	"""
		Getter for the Id for this Thing
	
		@returns
		@uuid A Unique Identifier (UUID)	
	"""
	return id.uuid
	
#	@GODOT


func _init():
	Logger.trace("thing._init")
	id = UUID.new()

