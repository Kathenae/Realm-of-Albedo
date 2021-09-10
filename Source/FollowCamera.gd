extends Camera

var is_in_fly_mode = false

# Props for Fly mode
var mouse_speed = Vector2.ZERO
export var movement_speed = 100
export var look_sensitivity = 5

# Props for Follow Mode
export (NodePath) var targetPath
onready var target = get_node(targetPath) as Spatial

var intro_path = []
var current_point = 200
var is_doing_intro = true

func setup(path : Array):
	intro_path = path
	var target_pos = intro_path[current_point] + Vector3.UP * 350
	translation = target_pos

func _process(delta):
	
	if (Input.is_action_just_pressed("toggle_cursor")):
		var mouse_mode = Input.get_mouse_mode()
		mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		Input.set_mouse_mode(mouse_mode)
	
	if is_doing_intro:
		var target_pos = intro_path[current_point] + Vector3.UP * 350
		translation = lerp(translation,target_pos,2 * delta)
		
		var look_target = intro_path[current_point - 20]
		var look_transform = transform.looking_at(look_target, Vector3.UP)
		var angle = look_transform.basis.get_euler()
		rotation.x = lerp_angle(rotation.x,angle.x,2 * delta)
		rotation.y = lerp_angle(rotation.y,angle.y,2 * delta)
		rotation.z = lerp_angle(rotation.z,angle.z,2 * delta)
		
		if translation.distance_to(target_pos) <= 250:
			current_point -= 1
			
			if current_point <= 30:
				is_doing_intro = false
		
		return
	
	if is_in_fly_mode:
		process_fly_mode(delta)
	else:
		process_follow_mode(delta)

func process_fly_mode(delta : float):
	if (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		process_look(delta)
		process_move(delta)

func process_look(delta):
	var new_rotation = rotation_degrees
	new_rotation.x += mouse_speed.y * look_sensitivity
	new_rotation.y += -mouse_speed.x * look_sensitivity
	new_rotation.x = clamp(new_rotation.x,-80,90)
	rotation_degrees = lerp(rotation_degrees,new_rotation,look_sensitivity * delta)
	mouse_speed = Vector2.ZERO

func process_move(delta):
	var horizontal = Utilities.input_actions_to_axis("move_left", "move_right")
	var vertical = Utilities.input_actions_to_axis("move_back", "move_forward")
	var height = Utilities.input_actions_to_axis("move_up","move_down")
	
	var move_velocity = Vector3.ZERO
	move_velocity += transform.basis.x * horizontal
	move_velocity += transform.basis.z * -vertical
	move_velocity.y = height
	move_velocity = move_velocity.normalized() * movement_speed * delta
	move_velocity.y *= 0.25
	
	translation += move_velocity

func _input(event):
	
	if event is InputEventMouseMotion:
		mouse_speed = event.relative

func _unhandled_key_input(event):
	
	if event.pressed and event.scancode == KEY_C:
		is_in_fly_mode = not is_in_fly_mode

func process_follow_mode(delta : float):
	
	var target_pos = target.translation + (target.transform.basis.z * 50) + Vector3.UP * 50
	translation = lerp(translation,target_pos,2 * delta)
	
	var looK_transform = transform.looking_at(target.translation + target.transform.basis.z * -150, Vector3.UP)
	var angle = looK_transform.basis.get_euler()
	rotation.x = lerp_angle(rotation.x,angle.x,3 * delta)
	rotation.y = lerp_angle(rotation.y,angle.y,3 * delta)
	rotation.z = lerp_angle(rotation.z,angle.z,3 * delta)
	
