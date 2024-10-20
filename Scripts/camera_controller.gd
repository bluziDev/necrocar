extends Camera3D

#@export var approach_speed : float
@export var lerp_speed : float
#@onready var linear_pos = global_position
@export var target_node : Node3D
@export var follow_offset : Vector3

func _process(delta):
	var target_pos = target_node.global_position + follow_offset
	#var linear_dif = target_pos - global_position
	#var approach_delta = approach_speed * delta
	#if linear_dif.length() < approach_delta:
	#	linear_pos = target_pos
	#else:
	#	linear_pos += approach_delta * linear_dif.normalized()
	#global_position = lerp(global_position,linear_pos,clamp(lerp_speed * delta,0,1))
	global_position = lerp(global_position,target_pos,clamp(lerp_speed * delta,0,1))
	pass
