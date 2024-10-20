extends Node3D

@export var spring_force : float
@export var spring_damp : float
@onready var parent = get_parent()
var up = Vector3(0,1,0)
var spring_velocity = Vector3(0,0,0)

func _process(delta):
	var up_difference = parent.ground_norm - up
	spring_velocity += sign(up_difference) * spring_force * delta
	spring_velocity /= 1 + spring_damp * delta
	up += spring_velocity * delta
	look_at(global_position + up,parent.move_dir)
