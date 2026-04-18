extends Node3D

#Экспортируемые ссылки на узлы
@export var floor_mesh: MeshInstance3D
@export var wall_front: MeshInstance3D
@export var wall_back: MeshInstance3D
@export var wall_left: MeshInstance3D
@export var wall_right: MeshInstance3D

func _ready():
	#Проверяем, что все ссылки назначены
	if not floor_mesh or not wall_front or not wall_back or not wall_left or not wall_right:
		printerr("Не все ссылки на стены/пол назначены в инспекторе!")
		return
	
	var width = RoomSettings.room_width
	var depth = RoomSettings.room_depth
	_create_room(width, depth)

func _create_room(width: float, depth: float):
	var wall_height = 2.5
	var wall_thickness = 0.1

	#Убедимся, что у каждого MeshInstance3D есть BoxMesh
	_ensure_box_mesh(floor_mesh)
	_ensure_box_mesh(wall_front)
	_ensure_box_mesh(wall_back)
	_ensure_box_mesh(wall_left)
	_ensure_box_mesh(wall_right)

	#Пол
	floor_mesh.mesh.size = Vector3(width, 0.05, depth)
	floor_mesh.position = Vector3(0, -0.025, 0)

	#Стены
	wall_front.mesh.size = Vector3(width, wall_height, wall_thickness)
	wall_front.position = Vector3(0, wall_height / 2, depth / 2)

	wall_back.mesh.size = Vector3(width, wall_height, wall_thickness)
	wall_back.position = Vector3(0, wall_height / 2, -depth / 2)

	wall_left.mesh.size = Vector3(wall_thickness, wall_height, depth)
	wall_left.position = Vector3(-width / 2, wall_height / 2, 0)

	wall_right.mesh.size = Vector3(wall_thickness, wall_height, depth)
	wall_right.position = Vector3(width / 2, wall_height / 2, 0)

	_update_collisions()

func _ensure_box_mesh(mesh_instance: MeshInstance3D):
	if not mesh_instance.mesh:
		mesh_instance.mesh = BoxMesh.new()

func _update_collisions():
	_update_collision_for_mesh(floor_mesh)
	_update_collision_for_mesh(wall_front)
	_update_collision_for_mesh(wall_back)
	_update_collision_for_mesh(wall_left)
	_update_collision_for_mesh(wall_right)

func _update_collision_for_mesh(mesh_instance: MeshInstance3D):
	var static_body = mesh_instance.get_node_or_null("StaticBody3D")
	if static_body:
		var col_shape = static_body.get_node_or_null("CollisionShape3D")
		if col_shape and col_shape.shape is BoxShape3D:
			col_shape.shape.size = mesh_instance.mesh.size
