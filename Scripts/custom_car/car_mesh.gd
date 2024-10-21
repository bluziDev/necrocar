extends Node3D

@export var tilt_force : float
@export var tilt_damp : float
@onready var parent = get_parent()
var up = Vector3(0,1,0)
var tilt_speed = Vector3(0,0,0)
@export var pos_force : float
@export var pos_damp : float
var pos_offset = Vector3(0,0,0)
var pos_speed = Vector3(0,0,0)
@export var max_pos_offset : float
@export var mass : float
@onready var parent_vel = parent.linear_velocity

func _process(delta):
	#bouncy tilt
	var up_target = parent.ground_norm
	var up_difference = up_target - up
	tilt_speed += sign(up_difference) * tilt_force * delta
	tilt_speed /= 1 + tilt_damp * delta
	up += tilt_speed * delta
	var forward = parent.move_dir_xz
	look_at(global_position + up,forward)
	
	#bouny position offset
	pos_speed += (parent_vel - parent.linear_velocity) * mass * delta
	parent_vel = parent.linear_velocity
	pos_speed += -sign(pos_offset) * pos_force * delta
	pos_speed /= 1 + pos_damp * delta
	pos_offset += pos_speed * delta
	global_position = parent.global_position + pos_offset.normalized() * min(max_pos_offset,pos_offset.length())
