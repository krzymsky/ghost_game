extends Control

class VectorObject:
	var begin
	var end
	
	func _init(_begin, _end):
		begin = _begin
		end = _end

class DebugObject:
	var object
	var property
	var scale
	var width
	var color
	var vector_object
	var text
	var default_font
	
	func _init(_object, _property, _scale, _width, _color, _vector_object=null, _text=null):
		object = _object
		property = _property
		scale = _scale
		width = _width
		color = _color
		vector_object = _vector_object
		text = _text
		default_font = Control.new().get_font("")
		
	func draw_property_vector(node, camera):
		var start = camera.unproject_position(object.global_transform.origin)
		var end = camera.unproject_position(object.global_transform.origin + object.get(property) * scale)
		node.draw_line(start, end, color, width)
		node.draw_triangle(end, start.direction_to(end), width*2, color)
		
	func draw_vector(node, camera):
		var start = camera.unproject_position(vector_object.begin)
		var end = camera.unproject_position(vector_object.begin + vector_object.end * scale)
		node.draw_line(start, end, color, width)
		node.draw_triangle(end, start.direction_to(end), width*2, color)
		
	func draw_text(node, camera):
		var pos = camera.unproject_position(vector_object.begin)
		node.draw_string(default_font, pos, text, color)
		
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
	
func add_vector(vector_object, color=Color(1,1,1,1), width=2, scale=1):
	objects.append(["draw_vector", DebugObject.new(null, null, scale, width, color, vector_object)])
	
func add_text(vector_object, text, color=Color(0,0,0,0.5), width=2, scale=1):
	objects.append(["draw_text", DebugObject.new(null, null, scale, width, color, vector_object, text)])
	
func add_cube(object, color=Color(1,1,1,1), width=2, scale=1):
	objects.append(["draw_quad", DebugObject.new(object, null, scale, width, color)])
		
func draw_triangle(pos, dir, size, color):
	var a = pos + dir * size
	var b = pos + dir.rotated(2*PI/3) * size
	var c = pos + dir.rotated(4*PI/3) * size
	var points = PoolVector2Array([a, b, c])
	draw_polygon(points, PoolColorArray([color]))
