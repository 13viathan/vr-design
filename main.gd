extends Node3D

#Экспортируемая переменная для назначения сцены меню в инспекторе
@export var menu_scene: PackedScene

#Ссылки на элементы комнаты
@onready var room_visuals = $RoomVisuals
@onready var floor_mesh = $RoomVisuals/Floor
@onready var walls = {
	"front": $RoomVisuals/WallFront,
	"back": $RoomVisuals/WallBack,
	"left": $RoomVisuals/WallLeft,
	"right": $RoomVisuals/WallRight
}

func _ready():
	_show_room_selection_menu()

func _show_room_selection_menu():
	if menu_scene:
		var menu = menu_scene.instantiate()
		add_child(menu)
		menu.position = Vector3(0, 1.5, -1.5)
		#Подключаем сигнал от меню
		if menu.has_signal("room_size_selected"):
			menu.room_size_selected.connect(_on_room_size_selected)
		else:
			printerr("В сцене меню отсутствует сигнал 'room_size_selected'!")
	else:
		printerr("Сцена меню не назначена в инспекторе! Создаю комнату по умолчанию.")
		_on_room_size_selected(4.0, 5.0)

func _on_room_size_selected(width: float, depth: float):
	print("Создаём комнату ", width, " x ", depth)
	_create_room(width, depth)
	

func _create_room(width: float, depth: float):
	var wall_height = 2.5
	var wall_thickness = 0.1

	#Пол
	floor_mesh.mesh = BoxMesh.new()
	floor_mesh.mesh.size = Vector3(width, 0.05, depth)
	floor_mesh.position = Vector3(0, -0.025, 0)

	#Стены
	walls["front"].mesh = BoxMesh.new()
	walls["front"].mesh.size = Vector3(width, wall_height, wall_thickness)
	walls["front"].position = Vector3(0, wall_height / 2, depth / 2)

	walls["back"].mesh = BoxMesh.new()
	walls["back"].mesh.size = Vector3(width, wall_height, wall_thickness)
	walls["back"].position = Vector3(0, wall_height / 2, -depth / 2)

	walls["left"].mesh = BoxMesh.new()
	walls["left"].mesh.size = Vector3(wall_thickness, wall_height, depth)
	walls["left"].position = Vector3(-width / 2, wall_height / 2, 0)

	walls["right"].mesh = BoxMesh.new()
	walls["right"].mesh.size = Vector3(wall_thickness, wall_height, depth)
	walls["right"].position = Vector3(width / 2, wall_height / 2, 0)

	_update_collisions()

func _update_collisions():
	#Пол
	var floor_static = floor_mesh.get_node_or_null("StaticBody3D")
	if floor_static:
		var col_shape = floor_static.get_node_or_null("CollisionShape3D")
		if col_shape and col_shape.shape is BoxShape3D:
			col_shape.shape.size = floor_mesh.mesh.size

	#Стены
	for wall in walls.values():
		var static_body = wall.get_node_or_null("StaticBody3D")
		if static_body:
			var col_shape = static_body.get_node_or_null("CollisionShape3D")
			if col_shape and col_shape.shape is BoxShape3D:
				col_shape.shape.size = wall.mesh.size
