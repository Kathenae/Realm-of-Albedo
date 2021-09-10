extends Camera
class_name PlayerCamera

var mouse_speed = Vector2.ZERO

export var movement_speed = 100
export var look_sensitivity = 5

func _process(delta):
	if (Input.is_action_just_pressed("toggle_cursor")):
		var mouse_mode = Input.get_mouse_mode()
		mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		Input.set_mouse_mode(mouse_mode)
	
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
