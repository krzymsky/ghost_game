extends Node

var speed = 200
var rotation_speed = 100

var velocity = Vector3.ZERO
var rotation_dir = 1.5

func handle_input(delta):
	#rotation_dir = 0
	velocity = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		rotation_dir -= 3 * delta
	if Input.is_action_pressed("ui_left"):
		rotation_dir += 3 * delta
	if Input.is_action_pressed("ui_down"):
		velocity -= Vector3.RIGHT.rotated(Vector3.UP, rotation_dir - PI/2) * speed * delta
	if Input.is_action_pressed("ui_up"):
		velocity += Vector3.RIGHT.rotated(Vector3.UP, rotation_dir - PI/2) * speed * delta
