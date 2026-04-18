extends Node3D

signal room_size_selected(width: float, depth: float)

@onready var width_slider = $UI/Panel/VBoxContainer/WidthSlider
@onready var depth_slider = $UI/Panel/VBoxContainer/DepthSlider
@onready var width_label = $UI/Panel/VBoxContainer/Label1
@onready var depth_label = $UI/Panel/VBoxContainer/Label2

func _ready():
	_on_width_slider_changed(width_slider.value)
	_on_depth_slider_changed(depth_slider.value)
	
	width_slider.value_changed.connect(_on_width_slider_changed)
	depth_slider.value_changed.connect(_on_depth_slider_changed)
	$UI/Panel/VBoxContainer/ConfirmButton.pressed.connect(_on_confirm_pressed)

func _on_width_slider_changed(value: float):
	width_label.text = "%.1f м" % value

func _on_depth_slider_changed(value: float):
	depth_label.text = "%.1f м" % value

func _on_confirm_pressed():
	RoomSettings.room_width = width_slider.value
	RoomSettings.room_depth = depth_slider.value
	emit_signal("room_size_selected", width_slider.value, depth_slider.value)
	get_tree().change_scene_to_file("res://room_scene.tscn")
