extends Spatial

func raycast(position : Vector3, direction : Vector3,distance = 100000) -> RaycastHit:
	var hit_data = get_world().direct_space_state.intersect_ray(position,position + direction * distance)
	
	if hit_data.empty():
		return null
	
	return RaycastHit.new(hit_data.collider,hit_data.position, hit_data.normal)

func raycast_screen_point(screen_point : Vector2) -> RaycastHit:
	var camera = get_viewport().get_camera()
	return raycast(camera.project_ray_origin(screen_point), camera.project_ray_normal(screen_point))

func input_actions_to_axis(negative : String,positive : String) -> float:
	var positive_input = float(Input.is_action_pressed(positive))
	positive_input *= Input.get_action_strength(positive)

	var negative_input = float(Input.is_action_pressed(negative))
	negative_input *= Input.get_action_strength(negative)
	
	return positive_input -negative_input

func spawn_object(prefab, position, parent : Node):
	var object = prefab.instance()
	object.translation = position
	parent.add_child(object)
	
	return object
