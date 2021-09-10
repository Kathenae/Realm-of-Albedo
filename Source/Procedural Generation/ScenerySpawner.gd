extends Spatial
class_name ScenerySpawner

export (Array,NodePath) var scenery_prefabs

var scenery_prefab = preload("res://Scenes/Sphere1.tscn")
var arch_prefab = preload("res://Scenes/arch.tscn")
var pole_prefab = preload("res://Scenes/Pole.tscn")
var cloud_prefab = preload("res://Scenes/Cloud.tscn")

export var sky_color = Color("8cd7ff")
export (Array,Color) var scenery_object_colors
export (Array,Color) var cloud_object_colors

export var object_density = 0.025
export var min_spawn_range = -6500
export var max_spawn_range =6500
export var min_spawn_height = -2000
export var max_spawn_height = 3000

export var cloud_density = 0.25
export var min_cloud_height = -1000
export var max_cloud_height = 3000

var object_materials = []
var cloud_materials = []
var path_points = []
var path_bases = []

func setup():
	
	for color in scenery_object_colors:
		var material = SpatialMaterial.new()
		material.roughness = 1
		material.albedo_color = color
		material.proximity_fade_enable = true
		material.proximity_fade_distance = 50
		object_materials.append(material)
	


func create_section(points,bases):
	
	for i in range(points.size()):
		
		if i <= 0:
			continue
		
		if i % 100 == 0:
			var arch = Utilities.spawn_object(arch_prefab, points[i],self) as Spatial
			arch.look_at(points[i] + bases[i].z * 100,Vector3.UP)
		
		if randf() <= object_density:
			spawn_object(points,bases,i)
		
		if randf() <= cloud_density:
			spawn_cloud(points,bases,i)

func spawn_object(points,bases,i : int):
	var point = points[i]
	var direction = bases[i].x
	direction.y = 0
	var spawn_point = point + direction * rand_range(min_spawn_range,max_spawn_range)
	spawn_point.y += rand_range(min_spawn_height,max_spawn_height)
	var scenery = Utilities.spawn_object(scenery_prefab, spawn_point,self) as MeshInstance
	scenery.material_override = object_materials[randi() % object_materials.size()]
	var radius = (450 * (randf() + 0.5) )
	scenery.scale *= radius
	
	var pole = Utilities.spawn_object(pole_prefab,spawn_point,self) as Spatial
	pole.translation.y -= radius * 0.5

func spawn_cloud(points,bases,i:int):
	var point = points[i]
	var direction = bases[i].x
	direction.y = 0
	var spawn_point = point + direction * rand_range(-6500,6500)
	spawn_point.y += rand_range(min_cloud_height,max_cloud_height)
	var cloud = Utilities.spawn_object(cloud_prefab,spawn_point,self)
	cloud.scale *=  rand_range(10,80)

func spawn_arch():
	
	
	pass
