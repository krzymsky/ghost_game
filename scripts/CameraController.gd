extends Spatial

onready var outer_gimbal = self
onready var inner_gimbal = $InnerGimbal

var rotation_speed = PI/2
var max_zoom = 20
var min_zoom = 0.5
var zoom_speed = 0.5
var zoom = 6

func _process(delta):
	var y_rotation = 0
	if Input.is_action_pressed("camera_left"):
		y_rotation -= 1
	elif Input.is_action_pressed("camera_right"):
		y_rotation += 1
	outer_gimbal.rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
	
	var x_rotation = 0
	if Input.is_action_pressed("camera_up"):
		x_rotation -= 1
	elif Input.is_action_pressed("camera_down"):
		x_rotation += 1
	inner_gimbal.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)
	
	inner_gimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, -0.01)
	
	outer_gimbal.scale = lerp(outer_gimbal.scale, Vector3.ONE * zoom, zoom_speed)
	
func _unhandled_input(event):
	if event.is_action_pressed("camera_zoom_in"):
		zoom -= zoom_speed
	if event.is_action_pressed("camera_zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)
