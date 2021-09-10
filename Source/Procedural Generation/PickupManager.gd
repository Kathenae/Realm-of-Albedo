# Creates pickups on the road and tells other that they've been created or
# that they've been collected, once that happens ofc

extends Spatial
class_name PickupManager

signal created(pickup_type, pickup_node)
signal collected(pickup_type,pickup_node)

export var pickup_prefab = preload("res://Scenes/Pickup.tscn")

func setup(_player_node, _path, _path_bases):
	pass


func _on_road_generator_section_created(section,points, bases):
	spawn_coins_on_section(points,bases)
	spawn_powerups_on_section(points,bases)

func spawn_coins_on_section(points,bases):
	
	var last_spawn_at = 0
	var cluster_amount = randi() % 10 + 3
	
	for _i in range(cluster_amount):
		
		var spawn_at = randi() % (points.size() - 40)
		var lane = randi() % 3 - 1
		var amount = randi() % 10 + 10
		
		for _j in range(0,amount):
			
			var spawn_position = (points[spawn_at] + Vector3.UP * 10) + bases[spawn_at].x * lane * 20
			var spawned_coin = Utilities.spawn_object(pickup_prefab, spawn_position,self) as Pickup
			spawned_coin.type = Pickup.Type.COIN
			spawned_coin.get_node("mesh_instance").scale *= 3.5
			
			spawned_coin.connect("collected",self,"_on_pickup_collected",[Pickup.Type.COIN,spawned_coin])
			emit_signal("created",Pickup.Type.COIN, spawned_coin)
			
			spawn_at += 2
		
		last_spawn_at = spawn_at
	
	# print("[Pickup Manager] Spawned Coin Pickups")

func spawn_powerups_on_section(points, bases):
	
	var magnet_count = randi() % 4 + 2
	
	for _i in range(magnet_count):
		
		if randf() >= 1:
			continue
		
		var point_index = randi() % points.size()
		var point = points[point_index] + Vector3.UP * 10
		var lane = bases[point_index].x * (randi() % 3 - 1 * 20)
		var spawn_point = point + lane
		
		var powerup_type = Pickup.Type.MAGNET if randi() % 2 == 0 else Pickup.Type.SHIELD
		var spawned_pickup = Utilities.spawn_object(pickup_prefab,spawn_point,self) as Pickup
		spawned_pickup.type = powerup_type
		
		spawned_pickup.connect("collected",self,"_on_pickup_collected",[powerup_type,spawned_pickup])
		emit_signal("created",powerup_type,spawned_pickup)

func _on_pickup_collected(pickup_type,pickup_node):
	emit_signal("collected",pickup_type,pickup_node)
