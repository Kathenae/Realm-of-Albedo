extends Spatial

var current_shop = null

func _ready():
	VehicleFactory.apply_vehicle_visuals_to_instance(PlayerGarage.get_selected_vehicle(),$VehiclePreview/MeshInstance)

func _on_start_pressed():
	get_tree().change_scene_to(GameData.intro_scene)

func _on_garage_pressed():
	$UI/Control/menu_actions.hide()
	$camera_animation.play("center")
	$camera_animation.connect("animation_finished",self,"show_current_shop")

func show_current_shop(_a):
	$UI/Control/shop.visible = true
	
	if current_shop == null:
		current_shop = $UI/Control/shop/vehicles_shop
		current_shop.preview_mesh = $VehiclePreview/MeshInstance
		current_shop.enter()
	
	$camera_animation.disconnect("animation_finished",self,"show_current_shop")

func _on_garage_return_pressed():
	$UI/Control/shop.visible = false
	$camera_animation.play("offset")
	$camera_animation.connect("animation_finished",self,"show_menu_actions")
	
	if current_shop != null:
		current_shop.leave()

func show_menu_actions(_a):
	$VehiclePreview/MeshInstance.mesh = PlayerGarage.get_selected_vehicle().mesh
	$UI/Control/menu_actions.show()
	$camera_animation.disconnect("animation_finished",self,"show_menu_actions")

func _on_vehicles_pressed():
	if current_shop != null:
		current_shop.leave()
	
	$camera_animation.play("center")
	$camera_animation.connect("animation_finished",self,"show_shop",[$UI/Control/shop/vehicles_shop])

func _on_paint_pressed():
	
	if current_shop != null:
		current_shop.leave()
	
	$camera_animation.play("center")
	$camera_animation.connect("animation_finished",self,"show_shop",[$UI/Control/shop/vehicle_paint_shop])

func show_shop(_a,shop):
	
	current_shop = shop
	current_shop.preview_mesh = $VehiclePreview/MeshInstance
	current_shop.enter()
	
	$camera_animation.disconnect("animation_finished",self,"show_shop")

func _on_updgrades_pressed():
	print("upgrages_pressed")

func _on_exit_pressed():
	get_tree().quit()
