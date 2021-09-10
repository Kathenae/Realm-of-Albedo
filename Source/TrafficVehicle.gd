extends Spatial
class_name TrafficVehicle


signal overtaken

var path = []
var current_point_index = 0


var lane = 0
var move_direction = 0
var target_position = Vector3.ZERO
onready var speed = randi() % 250 + 100

var player
var overtaken = false


func setup_visuals(mesh, material):
	$MeshInstance.mesh = mesh
	$MeshInstance.set_surface_material(0,material)

func _process(delta):
	process_movement(delta)
	process_path_advacement(delta)

var can_look = false
func process_movement(delta : float):
	
	# Get the position we should be moving to
	target_position = path[current_point_index] + Vector3.UP * 5
	target_position += transform.basis.x * lane * 20
	
	# Moving
	var direction_to_target = (target_position - translation).normalized()
	translation += direction_to_target * speed * delta
	
	# Turning
	if can_look:
		look_at(target_position,Vector3.UP)
	
	can_look = true

func process_path_advacement(_delta : float):
	
	var distance_to_current_point = (target_position - translation).length()
	
	if distance_to_current_point <= 60:
		# Advance to the next point
		current_point_index += move_direction
		try_despawning()
	
	if current_point_index == player.current_point_index and move_direction >= 1 and !overtaken:
		overtaken = true
		emit_signal("overtaken")

func try_despawning():

	var is_too_ahead_player = (current_point_index >= player.current_point_index + 1000 and move_direction == 1)
	var is_too_behind_player = (current_point_index <= player.current_point_index - 100 and move_direction == -1)
	var has_run_out_of_road = current_point_index <= 0 or current_point_index >= path.size() - 1
	
	if is_too_ahead_player or is_too_behind_player or has_run_out_of_road:
		queue_free()
