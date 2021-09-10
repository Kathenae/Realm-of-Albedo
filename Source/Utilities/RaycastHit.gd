extends Object
class_name RaycastHit

var body : PhysicsBody
var point : Vector3
var normal : Vector3

func _init(hit_body, hit_point, hit_normal):
	self.body = hit_body
	self.point = hit_point
	self.normal = hit_normal
