
#
#	Copyright 2018, SpockerDotNet LLC
#
#	GDScript implementation on RFC4122 for creating
#	a UUID from a Random or Pseudo-Random Number
#
#	http://www.ietf.org/rfc/rfc4122.txt

extends Reference

var uuid setget , _get_uuid


#	PUBLIC

func create():
	return _create_uuid()
	

#	PRIVATE
	
func _get_uuid():
	return uuid	
		
func _create_uuid():
	
	var s = []
	var hex = "0123456789abcdef"
	
	for i in range(37):
		s.append(hex.substr(floor(rand_range(0,16)), 1))
		
	s[14] = "4"
	s[19] = hex.substr((s[19] && 3) || 8, 1)
	s[8] = "-"
	s[13] = "-"
	s[18] = "-"
	s[23] = "-"
		
	var uuid = ""
	for i in range(s.size()-1):
		uuid += s[i]
		
	return uuid

#	GODOT
	
func _init():
	Logger.trace("UUID:_init")
	uuid = create()
	
	