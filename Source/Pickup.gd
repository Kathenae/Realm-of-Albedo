extends Area
class_name Pickup

signal collected
enum Type {COIN,MAGNET,SHIELD}

var collect_sound = preload("res://Sounds/mixkit-select-click-1109.wav")
var type_meshes = [preload("res://Models/Coin.mesh"),preload("res://Models/Magnet.mesh"),preload("res://Models/Shield.mesh")]
var type setget set_type


func set_type(value):
	type = value
	$mesh_instance.mesh = type_meshes[type]

func _on_Area_body_entered(body):
	
	if body is PlayerVehicle:
		var asp = AudioStreamPlayer3D.new()
		asp.stream = collect_sound
		get_parent().add_child(asp)
		asp.translation = translation
		asp.play()
		emit_signal("collected")
		queue_free()
