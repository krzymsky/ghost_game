extends KinematicBody

var speed = 10
var rotation_speed = 100

var velocity = Vector3.ZERO
var rotation_dir = 1.5

var path = []

onready var level_controller = $"../Level"

func _physics_process(delta):
	if path.size() > 0:
		velocity = path[0] - global_transform.origin
		#print(move_vector)
		#print(path[path_index])
		#print(global_transform.origin)
		if velocity.length() < 0.1:
			velocity = Vector3.ZERO
			path.remove(0)
		else:
			look_at(global_transform.origin - velocity, Vector3.UP)
			move_and_slide(velocity.normalized() * speed, Vector3.UP)
			
func move_to(target_position):
	#path = level_controller.navigation.get_simple_path(global_transform.origin, target_position)
	path = level_controller.astar_get_path(global_transform.origin, target_position)
	print(path)
	
func snap_to_closest_tile():
	var closest_tile = level_controller.grid_get_tile_center(global_transform.origin)
	global_transform.origin.x = closest_tile.x
	global_transform.origin.z = closest_tile.z
	
func is_walking():
	return path.size() > 0
