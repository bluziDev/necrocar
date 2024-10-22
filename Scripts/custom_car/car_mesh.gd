extends Node3D

@export var tilt_force : float
@export var tilt_damp : float
@onready var parent = get_parent()
var up = Vector3(0,1,0)
var up_wheels = Vector3(0,1,0)
var tilt_speed = Vector3(0,0,0)
var tilt_speed_wheels = Vector3(0,0,0)
@export var pos_force : float
@export var pos_damp : float
var pos_offset = Vector3(0,0,0)
var pos_speed = Vector3(0,0,0)
@export var max_pos_offset : float
@export var mass : float
@onready var parent_vel = parent.linear_velocity
@onready var wheels = get_node("Wheels")
@onready var up_target = parent.ground_norm
@onready var last_up_target = up_target
var last_target_difference = 0
@export var target_approach : float
@onready var up_target_target = up_target
@export var mass_wheels : float

func _process(delta):
	#bouncy tilt
	if (parent.ground_norm - up_target_target).length() > 0.0001:
		up_target_target = parent.ground_norm
		last_target_difference = (parent.ground_norm - up_target).length()
		
	#var up_target_target = parent.ground_norm
	var up_target_difference = up_target_target - up_target
	var target_approach_delta = target_approach * last_target_difference * delta
	if up_target_difference.length() <= target_approach_delta:
		up_target = up_target_target
	else:
		up_target += up_target_difference.normalized() * target_approach_delta 
	up_target = up_target.normalized()
	var up_difference = up_target - up
	tilt_speed += sign(up_difference) * tilt_force * delta
	tilt_speed /= 1 + tilt_damp * delta
	up += tilt_speed * delta
	#up = up_target
	var forward = parent.move_dir_xz
	look_at(global_position + up,forward)
	var wheels_up = up.reflect(up_target) * Vector3(mass / mass_wheels,1,mass / mass_wheels)
	wheels.look_at(global_position + wheels_up,forward)
	
	#bouncy position offset
	pos_speed += (parent_vel - parent.linear_velocity) * mass * delta
	parent_vel = parent.linear_velocity
	pos_speed += -sign(pos_offset) * pos_force * delta
	pos_speed /= 1 + pos_damp * delta
	pos_offset += pos_speed * delta
	var offset_clamped = pos_offset.normalized() * min(max_pos_offset,pos_offset.length())
	var offset_clamped_wheels = -pos_offset.normalized() * min(max_pos_offset,pos_offset.length() * (mass / mass_wheels))
	global_position = parent.global_position + offset_clamped
	wheels.global_position = parent.global_position + offset_clamped_wheels
