extends Spatial
class_name WorldLabel

export var text = "Hello"
var position : Vector3
var label : Label

func _init(text : String, position):
	self.text = text
	self.position = position
	
	label = Label.new()
	label.text = text
	label.align = Label.ALIGN_CENTER
	label.modulate = Color.black
	add_child(label)

func _process(delta):
	label.text = text
	label.align = Label.ALIGN_CENTER
	label.rect_position = get_viewport().get_camera().unproject_position(position)
