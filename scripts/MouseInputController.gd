extends Spatial

onready var position_indicator = $MousePositionIndicator
onready var level_controller   = $"../Level"

func _ready():
	position_indicator.visible = false

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			var camera = get_viewport().get_camera()
			var ray_origin    = camera.project_ray_origin(event.position)
			var ray_direction = camera.project_ray_normal(event.position)
			var ray_hit = get_world().direct_space_state.intersect_ray(ray_origin, ray_direction * 1000)
			if ray_hit:
				var grid_map    = level_controller.grid_map
				var tile_size   = grid_map.cell_size
				var tile_pos    = grid_map.world_to_map(ray_hit.position)
				var tile_center = tile_pos * tile_size + tile_size/2
				
				position_indicator.global_transform.origin = tile_center + Vector3.DOWN * 0.7
				position_indicator.visible = true
				
				print(tile_pos)
				GameGlobals.emit_signal("grid_tile_clicked", tile_pos)

#var ray_object
#
#func _ready():
#	ray_object = DebugLayer.draw.VectorObject.new(Vector3.ZERO, Vector3.ZERO)
#	DebugLayer.draw.add_vector(ray_object)
#
#func _unhandled_input(event):
#	if event is InputEventMouseMotion:
#		#print(event.position)
#		#position_indicator.global_transform.origin = get_viewport().get_camera().project_position(event.position, 50)
#		var camera = get_viewport().get_camera()
#		var ray_origin = camera.project_ray_origin(event.position)
#		var ray_direction = camera.project_ray_normal(event.position)
#		ray_object.begin = ray_origin
#		ray_object.end = ray_direction * 100
#		#position_indicator.global_transform.origin = ray_object.begin + ray_object.end
#		var ray_hit = get_world().direct_space_state.intersect_ray(ray_origin, ray_direction * 1000)
#		if ray_hit:
#			#print(ray_hit)
#			#position_indicator.global_transform.origin = ray_hit.position
#			var grid_pos = grid_map.world_to_map(ray_hit.position)
#			var grid_tile = grid_map.get_cell_item(grid_pos.x, grid_pos.y, grid_pos.z)
#			#print(grid_pos)
#			position_indicator.global_transform.origin = grid_pos * grid_map.cell_size + grid_map.cell_size/2
