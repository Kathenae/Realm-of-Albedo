extends Node
class_name StringUtils

static func put_space_after_3_letters(value : String) -> String:
	
	var formated_string = value as String
	
	for i in range(value.length(),0,-3):
		formated_string = formated_string.insert(i," ")
	
	formated_string.erase(formated_string.length() - 1,1)
	return formated_string

static func get_month_name(month : int) -> String:
	var months = ["Null","January", "February", "March", "April","May", "June", "July", "August", "September", "October", "November","December"]
	return months[month]
