extends Reference
class_name VehicleData

signal color_changed(color_name, new_color)

var name setget set_name, get_name
var hit_points = 100
var min_speed = 0
var top_speed = 225
var acceleration = 15
var handling = 1.5
var break_strength = 500

var factory_mesh_id : int
var mesh : Mesh
var materials = {}

var primary_color : Color setget set_primary_color
var secondary_color : Color setget set_secondary_color
var windows_color : Color setget set_windows_color
var lights_color : Color setget set_lights_color
var extra_color : Color setget set_extra_color

func _init(v_factory_mesh_id : int, characteristics : Dictionary, v_mesh : Mesh, v_materials : Dictionary):
	self.factory_mesh_id = v_factory_mesh_id
	self.hit_points = characteristics.hit_points
	self.min_speed = characteristics.min_speed
	self.top_speed = characteristics.top_speed
	self.acceleration = characteristics.acceleration
	self.handling = characteristics.handling
	self.break_strength = characteristics.break_strength
	
	self.mesh = v_mesh
	self.materials  = v_materials

func set_name(value : String):
	name = value

func get_name() -> String:
	return name

func set_primary_color(color : Color):
	set_color("primary", color)

func set_secondary_color(color : Color):
	set_color("secondary", color)

func set_windows_color(color : Color):
	set_color("windows", color)

func set_lights_color(color : Color):
	set_color("secondary", color)

func set_extra_color(color : Color):
	set_color("extra", color)

func set_color(color_name : String, color : Color):
	
	if materials.has(color_name) == false:
		printerr("Vehicle does not have a color named " + color_name)
	
	materials[color_name].albedo_color = color
	emit_signal("color_changed",color_name,color)
	pass
