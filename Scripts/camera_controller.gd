extends Camera3D

#@export var approach_speed : float
@export var lerp_speed : float
#@onready var linear_pos = global_position
@export var target_node : Node3D
@export var follow_offset : Vector3
@export var look_ahead : Vector3
var speed_offset = Vector3(0,0,0)

func _ready():
	speed_offset = look_ahead * target_node.linear_velocity

func _process(delta):
	speed_offset = (speed_offset + look_ahead * target_node.linear_velocity) / 2
	var target_pos = target_node.global_position + follow_offset + speed_offset
	#var linear_dif = target_pos - global_position
	#var approach_delta = approach_speed * delta
	#if linear_dif.length() < approach_delta:
	#	linear_pos = target_pos
	#else:
	#	linear_pos += approach_delta * linear_dif.normalized()
	#global_position = lerp(global_position,linear_pos,clamp(lerp_speed * delta,0,1))
	global_position = lerp(global_position,target_pos,1 - pow(lerp_speed,delta))
	pass
