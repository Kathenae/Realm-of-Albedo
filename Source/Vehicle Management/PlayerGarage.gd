extends Node

var selected_vehicle_id = 0

# Vehicle Ownership flags
var vehicle_ownership = {0 : true}
# Vehicle upgrades
var vehicle_upgrades = {}
var vehicle_colors = {}
var loaded_vehicles = {}

func get_selected_vehicle() -> VehicleData:
	return get_vehicle(selected_vehicle_id)

func get_vehicle(vehicle_factory_id) -> VehicleData:
	
	if loaded_vehicles.has(vehicle_factory_id) == false:
		_load_vehicle(vehicle_factory_id)
	
	return loaded_vehicles[vehicle_factory_id]

func _load_vehicle(vehicle_factory_id) -> void:
	
	var vehicle = VehicleFactory.clone_vehicle(vehicle_factory_id)
	
	if vehicle_colors.has(vehicle_factory_id):
		var colors = vehicle_colors[vehicle_factory_id]
		
		for color_name in colors:
			var color = Color(colors[color_name])
			vehicle.set_color(color_name,color)
			print("set color ", color)
	
	loaded_vehicles[vehicle_factory_id] = vehicle
	vehicle.connect("color_changed",self,"on_vehicle_painted",[vehicle_factory_id])

func has_vehicle(vehicle_factory_id):
	return vehicle_ownership.has(vehicle_factory_id)

func add_to_garage(vehicle_factory_id : int):
	vehicle_ownership[vehicle_factory_id] = true

func total_owned_vehicle() -> int:
	return vehicle_ownership.size()

func on_vehicle_painted(color_name, new_color : Color, vehicle_id):
	
	if vehicle_colors.has(vehicle_id) == false:
		vehicle_colors[vehicle_id] = {}
	
	vehicle_colors[vehicle_id][color_name] = new_color.to_html()
	print("Painted " + color_name + " on vehicle " + str(vehicle_id))
	
	GameData.save_data()

## SERIALIZATION ##
func save_data(save_file : File):
	
	var loose_data = {
		"selected_vehicle_id" : selected_vehicle_id
	}
	
	save_file.store_line(to_json(vehicle_ownership))
	save_file.store_line(to_json(vehicle_colors))
	save_file.store_line(to_json(vehicle_upgrades))
	save_file.store_line(to_json(loose_data))

func load_data(save_file : File):
	
	var vehicle_ownership_data = parse_json(save_file.get_line())as Dictionary
	var vehicle_colors_data = parse_json(save_file.get_line()) as Dictionary
	var vehicle_upgrades_data = parse_json(save_file.get_line()) as Dictionary
	var loose_data = parse_json(save_file.get_line())
	
	for id in vehicle_ownership_data:
		vehicle_ownership[int(id)] = vehicle_ownership_data[id]
	
	for id in vehicle_colors_data:
		vehicle_colors[int(id)] = vehicle_colors_data[id]
	
	for id in vehicle_upgrades_data:
		vehicle_upgrades[int(id)] = vehicle_upgrades_data[id]
	
	selected_vehicle_id = int(loose_data.selected_vehicle_id)
