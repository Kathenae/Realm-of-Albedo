extends Spatial

export var effect_range = 30 setget set_range
export var attract_strength = 1

var is_activated = true
var attracted_objects = []

func set_range(value : float):
	effect_range = value
	$CollisionShape.shape.radius = effect_range
	print("set_range")

func _on_magnet_area_entered(area):
	
	if area is Pickup and is_activated:
		if area.type == Pickup.Type.COIN:
			area.connect("collected",self,"on_attracted_destroyed",[area])
			attracted_objects.append(area)
			
			var target_position = area.translation
			target_position.y = $magnet_visual.translation.y
			$magnet_visual.look_at(target_position,Vector3.UP)

func on_attracted_destroyed(object):
	attracted_objects.erase(object)

func _process(delta):
	
	if not is_activated:
		return
	
	for attracted_object in attracted_objects:
		
		# Sometimes things go wrong and the object will be null
		if attracted_object == null:
			continue
		
		var start = attracted_object.global_transform.origin
		var end = $CollisionShape.global_transform.origin
		attracted_object.translation = lerp(start,end, attract_strength * delta)
		
		attracted_object.scale -= Vector3.ONE * attract_strength * delta * 2

func set_active(value : bool):
	is_activated = value
	$magnet_visual.visible = is_activated
	print("Magnet is Active: ", is_activated)
	
	for attracted in attracted_objects:
		attracted_objects.erase(attracted)
