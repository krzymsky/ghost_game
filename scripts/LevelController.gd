extends Spatial

var Label3D = preload("res://scenes/Label3D.tscn")

class TileType:
	const CRATE = 0
	const FLOOR = 1

onready var grid_map = $GridMap
onready var astar    = AStar2D.new()

var map_size 			= Vector2.ONE * 16
var path_start_position = Vector2.ZERO
var path_end_position 	= Vector2.ZERO
var path 	= []
var indexes = {}

func _ready():
	astar_init()
	#draw_debug_info()
		
func astar_init():
	# --- add walkable points
	var tiles = grid_map.get_used_cells()
	for tile in tiles:
		var index = astar.get_available_point_id()
		
		if is_tile_walkable(tile):
			tile = to_v2(tile)
		
			astar.add_point(index, tile)
			indexes[astar_get_tile_index(tile)] = index
	
	# --- connect walkable tiles
	for tile in tiles:
		if not is_tile_walkable(tile):
			continue
		tile = to_v2(tile)
		for local_y in range(3):
			for local_x in range(3):
				var tile_relative = Vector2(tile.x + local_x - 1, tile.y + local_y - 1)
				if tile == tile_relative:
					continue
				var tile_relative_index = astar_get_tile_index(tile_relative)
				if tile_relative_index in indexes:
					var index = indexes[astar_get_tile_index(tile)]
					var relative_index = indexes[tile_relative_index]
					if not astar.are_points_connected(index, relative_index):
						#print("connected: %d [%d x %d] : %d [%d x %d]" % 
						#		[index, tile.x, tile.z, relative_index, tile_relative.x, tile_relative.z])
						astar.connect_points(index, relative_index, true)
		
func astar_get_tile_index(tile):
	return str(int(round(tile.x))) + "," + str(int(round(tile.y)))
	
func to_v2(v):
	return Vector2(v.x, v.z)
	
func is_tile_walkable(tile):
	var tile_type = grid_map.get_cell_item(tile.x, tile.y, tile.z)
	return tile_type == TileType.FLOOR
	
func astar_get_path(world_start, world_end):
	path_start_position = to_v2(grid_map.world_to_map(world_start))
	path_end_position   = to_v2(world_end) #grid_map.world_to_map(world_end)
						  #TOFIX world_end is actually in map coordinates
						
	if not astar_get_tile_index(path_end_position) in indexes:
		return []
						
	astar_recalculate_path()
	
	var path_world = []
	for tile in path:
		var point_world = grid_map.map_to_world(tile.x, 0, tile.y)
		point_world.y = 0.25
		path_world.append(point_world)
	return path_world
	
func astar_recalculate_path():
	var start_index = indexes[astar_get_tile_index(path_start_position)]
	var end_index 	= indexes[astar_get_tile_index(path_end_position)]
	path = astar.get_point_path(start_index, end_index)
	
func grid_get_tile_center(world_position):
	var tile_position = grid_map.world_to_map(world_position)
	return tile_position * grid_map.cell_size + grid_map.cell_size/2
	
func draw_debug_info():
	var tiles = grid_map.get_used_cells()
	for tile in tiles:
		var point = grid_map.map_to_world(tile.x, tile.y, tile.z)
		#var mesh = MeshInstance.new()
		#mesh.mesh = CubeMesh.new()
		#mesh.global_transform.origin = point
		#mesh.scale = Vector3.ONE * 0.1
		#var label = Label3D.instance()
		#label.global_transform.origin = point
		#add_child(label)
		var pos = DebugLayer.draw.VectorObject.new(point - Vector3(0, 1, -0.5), null)
		var pos2 = DebugLayer.draw.VectorObject.new(point - Vector3(0.5, 1, -0.5), null)
		tile = to_v2(tile)
		DebugLayer.draw.add_text(pos, "%d x %d" % [tile.x, tile.y])
		DebugLayer.draw.add_text(pos2, "id: %d" % indexes[astar_get_tile_index(tile)])
		#add_child(mesh)
