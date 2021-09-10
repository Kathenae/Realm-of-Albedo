extends Spatial

export var material : SpatialMaterial

signal section_created(points,bases)

var sphere_prefab = preload("res://Scenes/Sphere1.tscn")
var island_prefab = preload("res://Scenes/Island.tscn")

var path_points = []
var point_transforms = []
var num_of_points = 1000

var road_width = 80
var curb_height = 10
var curb_inset = 0
var curb_width = 15

var road_color = Color("3c3281")
var curb_side_color = Color("324b81")
var curb_top_color = Color("37517f")

var noise
var noise2

var last_point = Vector3.ZERO
var current_index = 0
var player

func setup(player_node):
	self.player = player_node
	initialize_noise()
	create_road_section(1000)

func _process(_delta):
	if current_index - player.current_point_index < 1000:
		create_road_section(1000)

func initialize_noise():
	
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 2
	noise.persistence = 1
	
	noise2 = OpenSimplexNoise.new()
	noise2.seed = randi()
	noise2.octaves = 4
	noise2.period = 2
	noise2.persistence = 1

func create_road_section(length):
	
	var road_vertices = []
	var section_points = []
	var section_bases = []
	
	
	for i in range(current_index, current_index + length):
		
		var point = last_point
		var yn = noise2.get_noise_1d(float(i) / 400) + 0.5
		point.y = round(yn * 1500)
		path_points.append(point)
		
		var n = noise.get_noise_1d(float(i) / 250)
		var angle = deg2rad(n * 360)
		var direction = Basis(Vector3.UP,angle)
		
		point_transforms.append(direction)
		section_bases.append(direction)
		section_points.append(point)
		
		# NOTE: removing this causes gaps between road sections/chunks
		if i != current_index + length - 1:
			var dir = direction.z
			last_point += (dir * 30)
			last_point.y = point.y
		
		# Calculate the left and right vertices used for triangulating the mesh
		var right = direction.x.normalized()
		var right_vertex = point
		right_vertex += right * road_width * 0.5
		var left_vertex = point
		left_vertex -= right * road_width * 0.5
		
		
		road_vertices.append(right_vertex)
		road_vertices.append(left_vertex)
	
	current_index += length - 1
	var section_mesh = triangulate(road_vertices,length)
	
	emit_signal("section_created",section_mesh,section_points,section_bases)
	

var st = SurfaceTool.new()
func triangulate(vertices, length):
	
	
	st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var i = 0
	var p_index = path_points.size() - length
	
	var last_v6
	var last_v8
	var last_v10
	var last_v12
	var last_v14
	var last_v16
	var last_v18
	var last_v20
	
	while i < vertices.size() - 2:
		
		var direction = point_transforms[p_index]
		
		# Main Road
		var v1 = vertices[i]
		var v2 = vertices[i + 1]
		var v3 = vertices[i + 2]
		var v4 = vertices[i + 3]
		add_quad(v1,v2,v3,v4,road_color)
		
		# Inner right Side
		var v5 = v1 + Vector3.UP * curb_height
		var v6 = v3 + Vector3.UP * curb_height
		v5 += direction.x * curb_inset
		v6 += direction.x * curb_inset
		
		if last_v6 != null:
			v5 = last_v6
		last_v6 = v6
		
		add_quad(v5,v1,v6,v3,curb_side_color)
		
		# Inner left Side
		var v7 = v2 + Vector3.UP * curb_height
		var v8 = v4 + Vector3.UP * curb_height
		v7 -= direction.x * curb_inset
		v8 -= direction.x * curb_inset
		
		if last_v8 != null:
			v7 = last_v8
		last_v8 = v8
		
		add_quad(v2,v7,v4,v8,curb_side_color)
		
		# Top
		var v9 = v5 + direction.x * curb_width
		var v10 = v6 + direction.x * curb_width
		
		if last_v10 != null:
			v9 = last_v10
		last_v10 = v10
		
		add_quad(v9,v5,v10,v6,curb_top_color)
		
		var v11 = v7 - direction.x * curb_width
		var v12 = v8 - direction.x * curb_width
		
		if last_v12 != null:
			v11 = last_v12
		last_v12 = v12
		
		add_quad(v7,v11,v8,v12,curb_top_color)
		
		# Exterior Wall Sides
		var v13 = v9 + Vector3.DOWN * curb_height * 4
		var v14 = v10 + Vector3.DOWN * curb_height * 4
		
		if last_v14 != null:
			v13 = last_v14
		last_v14 = v14
		
		add_quad(v13,v9,v14,v10,curb_top_color)
		
		var v15 = v11 + Vector3.DOWN * curb_height * 4
		var v16 = v12 + Vector3.DOWN * curb_height * 4
		
		if last_v16 != null:
			v15 = last_v16
		last_v16 = v16
		
		add_quad(v11,v15,v12,v16,curb_top_color)
		
		# Bottom of the road
		var v17 = v13 - direction.x * road_width * 0.75
		var v18 = v14 - direction.x * road_width * 0.75
		
		if last_v18 != null:
			v17 = last_v18
		last_v18 = v18
		
		add_quad(v17,v13,v18,v14,curb_top_color)
		
		var v19 = v15 + direction.x * road_width
		var v20 = v16 + direction.x * road_width
		
		if last_v20 != null:
			v19 = last_v20
		last_v20 = v20
		
		add_quad(v15,v19,v16,v20,curb_top_color)

		i += 2
		p_index += 1
	
	st.generate_normals()
	var mesh = MeshInstance.new()
	material.vertex_color_use_as_albedo = true
	mesh.material_override = material
	mesh.mesh = st.commit()
	mesh.create_trimesh_collision()
	add_child(mesh)
	
	return mesh

func add_quad(v1 : Vector3,v2 : Vector3,v3 : Vector3,v4 : Vector3,color:Color):
	st.add_color(color)
	st.add_vertex(v3)
	st.add_vertex(v2)
	st.add_vertex(v1)
	st.add_vertex(v2)
	st.add_vertex(v3)
	st.add_vertex(v4)
