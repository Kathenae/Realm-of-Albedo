extends Control
class_name VehicleShop

var preview_mesh : MeshInstance
onready var current_vehicle_index = PlayerGarage.selected_vehicle_id
onready var current_vehicle = VehicleFactory.vehicles[current_vehicle_index]

func enter():
	visible = true
	setup_preview_mesh()
	update_selection_ui()

func leave():
	visible = false

func setup_preview_mesh():
	
	var vehicle_visuals = {
		"mesh" : VehicleFactory.get_default_mesh(current_vehicle_index), 
		"materials" : VehicleFactory.create_vehicle_materials()
	}
	
	VehicleFactory.apply_vehicle_visuals_to_instance(vehicle_visuals,preview_mesh)

func _on_previous_pressed():
	advance_vehicle(-1)
	update_selection_ui()
	update_preview_mesh()

func _on_next_pressed():
	advance_vehicle(1)
	update_selection_ui()
	update_preview_mesh()

func _on_buy_pressed():
	if GameData.player_balance - current_vehicle.price >= 0:
		PlayerGarage.add_to_garage(current_vehicle_index)
		PlayerGarage.selected_vehicle_id = current_vehicle_index
		GameData.player_balance -= current_vehicle.price
		GameData.save_data()
		
		update_selection_ui()
		update_preview_mesh()

func advance_vehicle(dir : int):
	current_vehicle_index += dir
	current_vehicle_index = clamp(current_vehicle_index,0,VehicleFactory.vehicles.size() - 1)
	current_vehicle = VehicleFactory.vehicles[current_vehicle_index]
	
	if PlayerGarage.has_vehicle(current_vehicle_index):
		PlayerGarage.selected_vehicle_id = current_vehicle_index

func update_preview_mesh():
	preview_mesh.mesh = current_vehicle.mesh

func update_selection_ui():
	var vehicle_name = current_vehicle.name
	$vehicle_detail_label.text = vehicle_name
	
	if PlayerGarage.has_vehicle(current_vehicle_index) == false:
		var price_text = StringUtils.put_space_after_3_letters(str(current_vehicle.price))
		$vehicle_detail_label.text += "\n" + price_text + "$"
		$buy.text = "Buy"
		$buy.disabled = false
	else:
		$buy.text = "Already Bought"
		$buy.disabled = true
	
	var vehicle_stats = current_vehicle.characteristics
	$"vehicle Stats/hit_points".text = "Durability:" + str(vehicle_stats.hit_points)
	$"vehicle Stats/max_speed".text = "Speed:" + str(vehicle_stats.top_speed)
	$"vehicle Stats/acceleration".text = "Acceleration:" + str(vehicle_stats.acceleration)
	$"vehicle Stats/handling".text = "Handling:" + str(vehicle_stats.handling)
