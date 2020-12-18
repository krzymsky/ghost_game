extends Control

class DebugObject:
	var object
	var property
	var scale
	var width
	var color
	
	func _init(_object, _property, _scale, _width, _color):
		object = _object
		property = _property
		scale = _scale
		width = _width
		color = _color
		
	func draw_property_vector(node, camera):
		var start = camera.unproject_position(object.global_transform.origin)
		var end = camera.unproject_position(object.global_transform.origin + object.get(property) * scale)
		node.draw_line(start, end, color, width)
		node.draw_triangle(end, start.direction_to(end), width*2, color)
		
	func draw_quad(node:Control, camera):
		var start = camera.unproject_position(object.global_transform.origin)
		var p1 = camera.unproject_position(object.global_transform.origin + Vector3(0, 0, 0) - Vector3(0.5, 0, 0.5))
		var p2 = camera.unproject_position(object.global_transform.origin + Vector3(2, 0, 0) - Vector3(0.5, 0, 0.5))
		var p3 = camera.unproject_position(object.global_transform.origin + Vector3(2, 0, 2) - Vector3(0.5, 0, 0.5))
		var p4 = camera.unproject_position(object.global_transform.origin + Vector3(0, 0, 2) - Vector3(0.5, 0, 0.5))
		#var end = camera.unproject_position(object.global_transform.origin + object.get(property) * scale)
		var line: PoolVector2Array = PoolVector2Array([
			p1,p2,p3,p4,p1
		])
		node.draw_polyline(line, color)
		
var objects = []

func _process(delta):
	#if not visible:
	if not GameGlobals.draw_debug:
		return
	update()
	
func _draw():
	var camera = get_viewport().get_camera()
	for o in objects:
		o[1].call(o[0], self, camera)
		
func add_property_vector(object, property, color=Color(1,1,1,1), width=2, scale=1):
	objects.append(["draw_property_vector", DebugObject.new(object, property, scale, width, color)])
	
func add_cube(object, color=Color(1,1,1,1), width=2, scale=1):
	objects.append(["draw_quad", DebugObject.new(object, null, scale, width, color)])
		
func draw_triangle(pos, dir, size, color):
	var a = pos + dir * size
	var b = pos + dir.rotated(2*PI/3) * size
	var c = pos + dir.rotated(4*PI/3) * size
	var points = PoolVector2Array([a, b, c])
	draw_polygon(points, PoolColorArray([color]))
