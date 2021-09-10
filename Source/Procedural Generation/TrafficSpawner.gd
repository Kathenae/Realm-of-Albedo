extends Spatial
class_name TrafficSpawner

export (Array,Color) var vehicle_colors
export (Array,Mesh) var vehicle_meshes = []

export var traffic_prefab = preload("res://Scenes/TrafficCar.tscn")

var vehicle_materials = []

var player : PlayerVehicle # Used to spawn traffic some distance ahead of the player
var path = []
var timer = 10.0

signal spawned

func setup(player_node, road_path):
	self.player = player_node
	self.path = road_path
	
	for color in vehicle_colors:
		var material = SpatialMaterial.new()
		material.albedo_color = color
		
		vehicle_materials.append(material)

func _process(delta):
	
	timer -= delta
	
	if timer <= 0:
		spawn_traffic_group()
		timer = randf() * 40 + 10 

func spawn_traffic_group():
	var traffic_size = int(rand_range(5,20))
	
	for i in range(traffic_size):
		
		var spawn_index = player.current_point_index + round(rand_range(250,750))
		var direction = 1 if randf() <= 0.25 else -1
		var lane = randi() % 3 - 1
		
		spawn_traffic(spawn_index,direction,lane)
	
	print("[Traffic Spawner] Spawned Traffic Group with " + str(traffic_size) + " vehicles")

func spawn_traffic(path_point_index, direction, lane) -> TrafficVehicle:
	
	var spawn_position = path[path_point_index] + Vector3.UP * 10
	var traffic = Utilities.spawn_object(traffic_prefab,spawn_position,self) as TrafficVehicle
	
	traffic.path = path
	traffic.lane = lane
	traffic.move_direction = direction
	traffic.current_point_index = path_point_index
	traffic.player = player
	
	var mesh = vehicle_meshes[randi() % vehicle_meshes.size()]
	var material = vehicle_materials[randi() % vehicle_materials.size()]
	traffic.setup_visuals(mesh,material)
	
	emit_signal("spawned", traffic)
	return traffic
