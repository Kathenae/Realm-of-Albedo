extends Control

var player_vehicle : PlayerVehicle

func setup(player_node : PlayerVehicle):
	self.player_vehicle = player_node
	
	$magnet_counter/label_container/label.text = str(player_vehicle.total_magnets) + "/" + str(GameData.max_magnets)
	$shield_counter/label_container/label.text = str(player_vehicle.total_shields) + "/" + str(GameData.max_shields)
	
	player_vehicle.connect("powerup_collected",self,"on_powerup_collected")
	player_vehicle.connect("powerup_activated",self,"on_powerup_activated")


func on_powerup_collected(_powerup_type,_new_total):
	print("Player collected new powerup")
	$magnet_counter/label_container/label.text = str(player_vehicle.total_magnets) + "/" + str(GameData.max_magnets)
	$shield_counter/label_container/label.text = str(player_vehicle.total_shields) + "/" + str(GameData.max_shields)

func on_powerup_activated(_powerup_type,_new_total): 
	print("Player activated a powerup")
	$magnet_counter/label_container/label.text = str(player_vehicle.total_magnets) + "/" + str(GameData.max_magnets)
	$shield_counter/label_container/label.text = str(player_vehicle.total_shields) + "/" + str(GameData.max_shields)
