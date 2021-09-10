extends KinematicBody
class_name PlayerVehicle

signal death
signal damaged(percent_left)
signal moved_to_new_section(road_section)

signal powerup_collected(powerup_type,new_total)
signal powerup_activated(powerup_type,new_total)

export var acceleration_curve : Curve

var impact_sounds = [
	preload("res://Sounds/car-crash.ogg")
]

var min_speed = 0
var max_speed = 250
var acelerarion = 120
var break_strength = 300
var current_speed = min_speed
var max_health = 3
var current_health = max_health
var turn_sensitivity = 1.5
var current_turn = 0
var points = []
var point_basis = []
var current_point_index = 0
var current_point = Vector3.ZERO
var velocity = Vector3.ZERO
var is_wrecked = false

# Powerups
var total_magnets = 0;
var total_shields = 0;

func _ready():
	load_selecte_vehicle()

func load_selecte_vehicle():
	
	var selected_vehicle = PlayerGarage.get_selected_vehicle()
	
	# change Visuals
	VehicleFactory.apply_vehicle_visuals_to_instance(selected_vehicle,$mesh)
	
	# Setup collider
	$body_collider.shape = $mesh.mesh.create_convex_shape()
	$area/collider.shape = $mesh.mesh.create_convex_shape()
	
	# Change vehicle driving characteristics
	min_speed = selected_vehicle.min_speed
	max_speed = selected_vehicle.top_speed
	turn_sensitivity = selected_vehicle.handling
	acelerarion = selected_vehicle.acceleration
	break_strength = selected_vehicle.break_strength
	max_health = selected_vehicle.hit_points
	current_health = max_health
	
	print(selected_vehicle.acceleration)

func _process(delta):
	
	if is_wrecked:
		return
	
	process_movement(delta)
	process_throtle(delta)
	process_turn(delta)
	process_motion(delta)
	handle_powerup_input()

## MOVEMENT 
func process_movement(delta : float) -> void:
	# Look where we're going
	var direction = (current_point - translation).normalized()
	var look_target = translation + direction * 50
	
	if look_target != translation and direction != Vector3.UP:
		var look_transform = transform.looking_at(look_target, Vector3.UP)
		var angle = look_transform.basis.get_euler()
		rotation.x = lerp_angle(rotation.x,angle.x,2 * delta)

	var point = current_point
	point.y = translation.y
	if translation.distance_to(point) <= 60:
		current_point_index += 1
		current_point = points[current_point_index] + Vector3.UP * 5

func process_throtle(delta : float) -> void:
	
	# Update speed
	var drive_input = Utilities.input_actions_to_axis("move_back", "move_forward")
	var speed_percent = inverse_lerp(min_speed,max_speed,current_speed)
	print(acelerarion)
	print(acceleration_curve.interpolate(speed_percent))
	var drive_amount = acelerarion * acceleration_curve.interpolate(speed_percent) if drive_input > 0 else -break_strength if drive_input < 0 else -50
	current_speed += drive_amount * delta
	current_speed = clamp(current_speed,min_speed,max_speed)
	$engine_sound.pitch_scale = 1 + inverse_lerp(0,250,current_speed)
	
	# Mve using velocity
	var move_velocity = -transform.basis.z * current_speed
	velocity.x = move_velocity.x
	velocity.z = move_velocity.z

func process_turn(delta : float) -> void:
	var turn_input = -Utilities.input_actions_to_axis("move_left", "move_right")
	var turning_weight = inverse_lerp(max_speed,min_speed,current_speed - max_speed * 0.5)
	current_turn = turn_sensitivity * turn_input * turning_weight * delta
	
	#Turning
	rotate(Vector3.UP,current_turn)

func process_motion(delta : float) -> void:
	
	var _slide_velocity = move_and_slide(velocity,Vector3.UP)
	
	if is_on_floor() == false:
		velocity.y = lerp(velocity.y, velocity.y - 20, 5 * delta) 
	else:
		velocity.y = lerp(velocity.y,0,2 * delta)


## TAKING DAMAGE
func _on_area_body_entered(body):
	
	if body.get_parent().has_meta("scenery"):
		emit_signal("moved_to_new_section", body.get_parent())
	
	if is_on_wall():
		var collision = get_slide_collision(get_slide_count() - 1)
		var collision_angle = atan2(collision.normal.x,collision.normal.z)
		collision_angle = abs(rad2deg(collision_angle))
		var speed_weight = inverse_lerp(0,180,collision_angle)
		current_speed = current_speed * speed_weight
	
	if is_wrecked:
		return
	
	if body.is_in_group("Traffic"):
		var took_damage = take_damage()
		if took_damage:
			translation.y += 10

func take_damage() -> bool:
	
	if $shield.visible:
		return false
	
	$crash_sound.stream = impact_sounds[randi() % impact_sounds.size()]
	$crash_sound.play()
	current_health -= 1
	
	var percent_left = inverse_lerp(0,max_health,current_health)
	emit_signal("damaged",percent_left)
	
	if current_health <= 0:
		die()
	
	return true

func die():
	$crash_sound.pitch_scale = 0.6
	$crash_sound.play()
	$engine_sound.stop()
	is_wrecked = true
	emit_signal("death")
	hide()


## POWERUPS
func _on_pickup_manager_collected(pickup_type, pickup_node):
	
	match(pickup_type):
		PickupType.MAGNET:
			total_magnets += 1
			total_magnets = clamp(total_magnets,0,GameData.max_magnets)
			emit_signal("powerup_collected",PickupType.MAGNET,total_magnets)
		PickupType.SHIELD:
			total_shields += 1
			total_shields = clamp(total_shields,0,GameData.max_shields)
			emit_signal("powerup_collected",PickupType.SHIELD,total_shields)

func handle_powerup_input():
	if Input.is_action_just_pressed("activate_magnet"):
		if total_magnets > 0:
			activate_magnet()
	
	if Input.is_action_just_pressed("activate_shield"):
		if total_shields > 0:
			activate_shield()

func activate_magnet():
	print("[Player Vehicle] Activate Magnet")
	var duration = clamp($magnet_timer.time_left + 30,0,30)
	$magnet_timer.start(duration)
	$magnet.set_active(true)
	total_magnets -= 1
	emit_signal("powerup_activated",PickupType.MAGNET,total_magnets)
	

func activate_shield():
	print("[Player Vehicle] Activate Shield")
	$shield.visible = true
	var duration = clamp($shield_timer.time_left + 30,0,30)
	$shield_timer.start(duration)
	total_shields -= 1
	emit_signal("powerup_activated",PickupType.SHIELD,total_shields)

func _on_magnet_timer_timeout():
	$magnet.set_active(false)

func _on_shield_timer_timeout():
	$shield.visible = false
