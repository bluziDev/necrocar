extends VehicleBody3D

@export var max_steer : float
@export var turn_speed : float
@export var engine_power : float

func _physics_process(delta):
	steering = move_toward(steering,Input.get_axis("steer_right","steer_left") * max_steer,turn_speed * delta)
	engine_force = Input.get_axis("drive_backward","drive_forward") * engine_power
