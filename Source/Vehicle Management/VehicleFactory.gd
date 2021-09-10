extends Node

var vehicles = [
	{"name" : "Corona",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 250,
			"acceleration" : 100,
			"handling" : 1.5,
			"break_strength" : 500,},
		"mesh" : preload("res://Models/HoverCar 2.mesh"),
		"price" : 0},
	{"name" : "Camper Van",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 250,
			"acceleration" : 100,
			"handling" : 1.5,
			"break_strength" : 500},
		"mesh" : preload("res://Models/HoverCar 11.mesh"),
		"price" : 4000},
	{"name" : "T Pickup",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 250,
			"acceleration" : 100,
			"handling" : 1.5,
			"break_strength" : 500},
		"mesh" : preload("res://Models/HoverCar 3.mesh"),
		"price" : 6000},
	{"name" : "S Sleight",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 250,
			"acceleration" :100,
			"handling" : 1.5,
			"break_strength" : 500},
		"mesh" : preload("res://Models/HoverCar 1.mesh"),
		"price" : 10000},
	{"name" : "Adrift",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 280,
			"acceleration" : 100,
			"handling" : 1.5,
			"break_strength" : 500},
		"mesh" : preload("res://Models/HoverCar 4.mesh"),
		"price" : 10000},
	{"name" : "Vector IV",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 280,
			"acceleration" : 100,
			"handling" : 1.5,
			"break_strength" : 500,},
		"mesh" : preload("res://Models/HoverCar 5.mesh"),
		"price" : 15000},
	{"name" : "Blimp",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 280,
			"acceleration" : 100,
			"handling" : 2,
			"break_strength" : 500},
		"mesh" : preload("res://Models/HoverCar 6.mesh"),
		"price" : 15000},
	{"name" : "Skywander",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 290,
			"acceleration" : 100,
			"handling" : 1.5,
			"break_strength" : 500,},
		"mesh" : preload("res://Models/HoverCar 7.mesh"),
		"price" : 25000},
	{"name" : "Pemmican",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 290,
			"acceleration" : 100,
			"handling" : 1.5,
			"break_strength" : 500},
		"mesh" : preload("res://Models/HoverCar 8.mesh"),
		"price" : 25000},
	{"name" : "Rooster",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 310,
			"acceleration" : 100,
			"handling" : 1.5,
			"break_strength" : 500},
		"mesh" : preload("res://Models/HoverCar 9.mesh"),
		"price" : 35000},
	{"name" : "Rooster T",
		"characteristics" : {
			"hit_points" : 3,
			"min_speed" : 0,
			"top_speed" : 325,
			"acceleration" : 100,
			"handling" : 1.5,
			"break_strength" : 500},
		"mesh" : preload("res://Models/HoverCar 10.mesh"),
		"price" : 35000},
]

func get_vehicle_stats(vehicle_factory_id : int) -> Dictionary:
	return vehicles[vehicle_factory_id].characteristics

func get_default_mesh(vehicle_factory_id : int) -> Mesh:
	return vehicles[vehicle_factory_id].mesh

func get_vehicle_name(vehicle_factory_id : int) -> String:
	return vehicles[vehicle_factory_id].name

func clone_vehicle(vehicle_factory_id : int) -> VehicleData:
	
	var vehicle_mesh = vehicles[vehicle_factory_id].mesh
	var materials = create_vehicle_materials()
#
	return VehicleData.new(
		vehicle_factory_id,
		vehicles[vehicle_factory_id].characteristics,
		vehicle_mesh,
		materials
	)

# Applies applies the correct visuals to the given mesh_instance given some vehicle_data
func apply_vehicle_visuals_to_instance(vehicle_data, mesh_instance : MeshInstance):
	mesh_instance.mesh = vehicle_data.mesh
	mesh_instance.set_surface_material(0,vehicle_data.materials["primary"])
	mesh_instance.set_surface_material(1,vehicle_data.materials["windows"])
	mesh_instance.set_surface_material(2,vehicle_data.materials["lights"])
	mesh_instance.set_surface_material(3,vehicle_data.materials["secondary"])

var default_primary = preload("res://Models/Base.material")
var default_secondary = preload("res://Models/Details.material")
var default_windows = preload("res://Models/Glass.material")
var default_lights = preload("res://Models/Light.material")
var default_extra = preload("res://Models/Details 2.material")

# Creates all the materials required for vehicles and assigns them default values
# returns a dictionary containing the created materials
func create_vehicle_materials() -> Dictionary:
	
	var materials = {}
	
	var primary = SpatialMaterial.new()
	var secondary = SpatialMaterial.new()
	var windows = SpatialMaterial.new()
	var lights = SpatialMaterial.new()
	var extra = SpatialMaterial.new()
	
	primary.roughness = default_primary.roughness
	primary.albedo_color = default_primary.albedo_color
	
	secondary.roughness = default_secondary.roughness
	secondary.albedo_color = default_secondary.albedo_color
	
	windows.roughness = default_windows.roughness
	windows.albedo_color = default_windows.albedo_color
	
	lights.roughness = default_lights.roughness
	lights.emission = default_lights.emission
	lights.emission = default_lights.albedo_color
	
	extra.roughness = default_extra.roughness
	extra.albedo_color = default_extra.albedo_color
	
	materials["primary"] = primary
	materials["secondary"] = secondary
	materials["windows"] = windows
	materials["lights"] = lights
	materials["extra"] = extra
	
	return materials
