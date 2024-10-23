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
@export var spin_damp : float
var wheel_speed = 0
@export var air_wheel_accel : float
var grounded = false
@export var speed_transfer : float

func _ready():
	ray.target_position = Vector3(0,-travel,0)
	ray.add_exception(rb)
	
func _physics_process(delta):
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
	
	if !grounded:
		if rb.grounded:
			rb.linear_velocity += (wheel_speed * wheel_radius * rb.move_dir - rb.linear_velocity.project(rb.move_dir)) * speed_transfer * 0.25
			
	grounded = rb.grounded
	if grounded:
		wheel_speed = rb.linear_velocity.project(rb.move_dir).length() * sign(rb.linear_velocity.dot(rb.move_dir)) / wheel_radius
	else:
		wheel_speed += air_wheel_accel * Input.get_axis("drive_forward","drive_backward") * delta
		wheel_speed /= 1 + spin_damp * delta
		
	mesh.rotation.x -= wheel_speed * delta
