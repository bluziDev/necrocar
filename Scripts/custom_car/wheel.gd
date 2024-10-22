extends Node3D

@onready var ray = get_node("RayCast3D")
@export var travel : float
@export var wheel_radius : float
@onready var parent = get_parent()
@onready var parent_last_pos = parent.global_position
@onready var mesh = get_node("Mesh")
@onready var rb = parent.get_parent().get_parent()
@onready var wheel_max_offset = travel - wheel_radius
@onready var wheel_offset = wheel_max_offset
@export var suspension_approach : float

func _ready():
	ray.target_position = Vector3(0,-travel,0)
	ray.add_exception(rb)
	
func _process(delta):
	var wheel_offset_target
	if ray.is_colliding():
		wheel_offset_target = (global_position - ray.get_collision_point()).length() - wheel_radius
		#wheel_speed = 
	else:
		wheel_offset_target = wheel_max_offset
		#wheel_offset = travel - wheel_radius
	var sus_approach_delta = suspension_approach * delta
	var target_difference = wheel_offset_target - wheel_offset
	if abs(target_difference) <= sus_approach_delta:
		wheel_offset = wheel_offset_target
	else:
		wheel_offset += sign(target_difference) * sus_approach_delta
	mesh.position = Vector3(0,-wheel_offset,0)
	
