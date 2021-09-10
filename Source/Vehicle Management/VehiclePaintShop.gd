extends Control
class_name VehiclePainShop

var preview_mesh : MeshInstance
var selected_vehicle : VehicleData
var current_edit_target : ColorRect

onready var mat = SpatialMaterial.new()

func _enter_tree():
	setup_edit_color_rects()
	setup_pick_color_rects()
	pass

func enter():
	update_selection()
	update_preview_mesh()
	update_edit_colors()
	show()

func leave():
	hide()

func update_selection():
	selected_vehicle = PlayerGarage.get_selected_vehicle()

func update_preview_mesh():
	VehicleFactory.apply_vehicle_visuals_to_instance(selected_vehicle, preview_mesh)

func update_edit_colors():
	for color_rect in $colors_to_edit.get_children():
		if color_rect is ColorRect:
			
			if color_rect.name == $colors_to_edit/selection_bg.name:
				continue
			
			var color_name = color_rect.name
			color_rect.color = selected_vehicle.materials[color_name].albedo_color

func setup_edit_color_rects():
	
	current_edit_target = $colors_to_edit/primary
	$colors_to_edit/selection_bg.rect_position.x = current_edit_target.rect_position.x - 2.5
	$colors_to_edit/selection_bg.rect_position.y = current_edit_target.rect_position.y - 2.5
	
	for color_rect in $colors_to_edit.get_children():
		if color_rect is ColorRect:
			
			if color_rect.name == $colors_to_edit/selection_bg.name:
				continue
			
			color_rect.connect("gui_input",self,"_on_edit_color_input",[color_rect])

func _on_edit_color_input(input_event, color_rect):
	if input_event is InputEventMouseButton:
		
		if input_event.pressed and input_event.button_index == BUTTON_LEFT:
			$colors_to_edit/selection_bg.rect_position.x = color_rect.rect_position.x - 2.5
			$colors_to_edit/selection_bg.rect_position.y = color_rect.rect_position.y - 2.5
			current_edit_target = color_rect

func setup_pick_color_rects():
	for color_rect in $colors/container.get_children():
		
		if color_rect is ColorRect:
			color_rect.connect("mouse_entered",self,"_on_pick_color_rect_mouse_entered",[color_rect])
			color_rect.connect("mouse_exited",self,"_on_pick_color_rect_mouse_exited",[color_rect])
			color_rect.connect("gui_input",self,"_on_pick_color_rect_gui_input",[color_rect])

func _on_pick_color_rect_mouse_entered(color_rect : ColorRect):
	color_rect.modulate = Color.white * 0.25
	pass

func _on_pick_color_rect_mouse_exited(color_rect : ColorRect):
	color_rect.modulate = Color.white

func _on_pick_color_rect_gui_input(input_event,color_rect : ColorRect):
	
	if input_event is InputEventMouseButton:
		if input_event.pressed and input_event.button_index == BUTTON_LEFT:
			var color_name = current_edit_target.name
			selected_vehicle.set_color(color_name, color_rect.color)
			current_edit_target.color = color_rect.color

