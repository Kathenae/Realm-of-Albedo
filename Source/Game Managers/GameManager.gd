# Responsible for setting up the various game components and do so in the correct order, in short LOADING and CLOSING the Playscene
# Should not do anything other than that

extends Spatial
class_name GameManager

func _ready():
	randomize()
	setup_scenery()
	setup_road()
	setup_player()
	setup_traffic()
	setup_pickups()
	setup_progress_manager()
	setup_ui()

func setup_scenery():
	$scenery_manager.setup()

func setup_road():
	var player = $player_vehicle
	$road_generator.setup(player)

func setup_player():
	var spawn_position = $road_generator.path_points[20]
	spawn_position.y += 10
	$player_vehicle.translation = spawn_position
	
	$player_vehicle.current_point = spawn_position
	$player_vehicle.current_point_index = 20
	
	var look_point = $road_generator.path_points[25]
	look_point.y = spawn_position.y
	$player_vehicle.look_at(look_point, Vector3.UP)
	
	$player_vehicle.points = $road_generator.path_points
	$player_vehicle.point_basis = $road_generator.point_transforms
	
	$player_camera.setup($road_generator.path_points)

func setup_traffic():
	var player = $player_vehicle
	var path = $road_generator.path_points
	$traffic_spawner.setup(player,path)

func setup_pickups():
	var player = $player_vehicle
	var path = $road_generator.path_points
	var path_bases = $road_generator.point_transforms
	$pickup_manager.setup(player,path,path_bases)

func setup_progress_manager():
	$progress_manager.setup($player_vehicle)

func setup_ui():
	$UI/main/player_status_ui.setup($player_vehicle)
