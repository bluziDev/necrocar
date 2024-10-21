extends RigidBody3D

@export var horsepower : float
var turn_speed = 0
@export var turn_power : float
@export var turn_damp : float
var ground_norm = Vector3(0,1,0)
var move_dir_xz = Vector3(0,0,1)
var drift_axis = move_dir_xz.cross(ground_norm).normalized()
var move_dir = drift_axis.cross(ground_norm).normalized()
@onready var pointer = get_node("Pointer")
@onready var ray = get_node("RayCast3D")
var ray_length = 0
var grounded = true
@export var grounded_dis : float
@export var drift_damp : float
@export var turn_transfer : float
var last_grounded_velocity = Vector3(0,0,0)

func _physics_process(delta):
	ray.global_rotation = Vector3(0,0,0)
	ray.target_position = Vector3(0,-100,0)
	if ray.is_colliding():
		ray.target_position = -ray.get_collision_normal() * 100
		if ray.is_colliding():
			ray_length = (ray.get_collision_point() - global_position).length()
			if ray_length <= grounded_dis:
				#if !grounded:
					#apply_central_impulse(last_grounded_velocity)
					#based on wheel speed
				grounded = true
				ground_norm = ray.get_collision_normal()
			else:
				grounded = false
		else:
			grounded = false
	else:
		grounded = false
	#move_dir = Input.get_axis("steer_right","steer_left") * turn_speed * delta
	if grounded:
		turn_speed += Input.get_axis("steer_right","steer_left") * turn_power * delta
		turn_speed /= 1 + turn_damp * delta
	move_dir_xz = move_dir_xz.rotated(Vector3(0,1,0),turn_speed * delta)
	drift_axis = move_dir_xz.cross(ground_norm).normalized()
	move_dir = drift_axis.cross(ground_norm).normalized()
	if grounded:
		#transfer momentum by turning
		linear_velocity = linear_velocity.rotated(ground_norm,turn_speed * turn_transfer * delta)
		#main drive force
		apply_central_force(horsepower * delta * move_dir * Input.get_axis("drive_forward","drive_backward"))
		#damp velocity side to side
		var drift_velocity = linear_velocity.project(drift_axis)
		var vel_no_drift = linear_velocity - drift_velocity
		drift_velocity /= 1 + drift_damp * delta
		linear_velocity = vel_no_drift + drift_velocity
		#var drift_damp_delta = drift_damp * delta
		#if drift_velocity.length() < drift_damp_delta:
		#	linear_velocity -= drift_velocity
		#else:
		#	linear_velocity -= drift_velocity.normalized() * drift_damp_delta
		#last_grounded_velocity = linear_velocity
		
	pointer.look_at(global_position + move_dir,Vector3(0,1,0))
