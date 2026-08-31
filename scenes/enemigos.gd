extends TileMapLayer

var spawner = preload("spawner.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cell in get_used_cells():
		
		var new_spawner = spawner.instantiate()
		new_spawner.position = map_to_local(cell)
		
		#print(get_cell_atlas_coords(cell))
		
		match get_cell_atlas_coords(cell):
			Vector2i(0,0):
				new_spawner.type = "planta"
			Vector2i(2,0):
				new_spawner.type = "flor"
			Vector2i(4,0):
				new_spawner.type = "hongo"
		
		add_child(new_spawner)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
