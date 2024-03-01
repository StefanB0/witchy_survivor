extends Node2D

const CHUNK_SIZE := 256

const TREE_LAYER := 0
const TREE_SOURCE := 0
const TREE_POOL: Array = [Vector2i(0, 0), Vector2i(2, 0)]
const TREE_PER_CHUNK_MIN := 1
const TREE_PER_CHUNK_MAX := 3

@export var player: CharacterBody2D
@export var log_on: bool

var player_chunk: Vector2i
var explored_chunks: Dictionary

@onready var TreeMap: TileMap = %TreesTileMap

#func _ready():
	#const GRID_SIZE = 3
	#for i in range(-GRID_SIZE, GRID_SIZE+1):
		#var line: Line2D = Line2D.new()
		#var line2: Line2D = Line2D.new()
		#add_child(line)
		#add_child(line2)
		#line.default_color = Color.WHITE
		#line2.default_color = Color.WHITE
		#line.width = 2
		#line2.width = 2
		#line.add_point(Vector2(GRID_SIZE*CHUNK_SIZE, i*CHUNK_SIZE))
		#line.add_point(Vector2(-GRID_SIZE*CHUNK_SIZE, i*CHUNK_SIZE))
		#line2.add_point(Vector2(i*CHUNK_SIZE, GRID_SIZE*CHUNK_SIZE))
		#line2.add_point(Vector2(i*CHUNK_SIZE, -GRID_SIZE*CHUNK_SIZE))

func _process(delta: float) -> void:
	calculate_player_chunk()
	generate_trees()

func calculate_player_chunk() -> void:
	var player_pos := player.global_position
	player_chunk.x = int(player_pos.x) / CHUNK_SIZE + int(signf(player_pos.x) + -1) / 2
	player_chunk.y = int(player_pos.y) / CHUNK_SIZE + int(signf(player_pos.y) + -1) / 2

func generate_trees() -> void:
	const GEN_RANGE = 5
	for i in range(-GEN_RANGE, GEN_RANGE+1):
		for j in range(-GEN_RANGE, GEN_RANGE+1):
			var chunk = Vector2i(player_chunk.x + i, player_chunk.y + j)
			if not explored_chunks.has(chunk):
				generate_tree(chunk)
				explored_chunks[chunk] = true

func generate_tree(chunk: Vector2i) -> void:
	if log_on:
		print("Generating trees for chunk ", chunk)
	
	var tree_count := randi_range(TREE_PER_CHUNK_MIN, TREE_PER_CHUNK_MAX)
	var tree_coords: Array = []
	while tree_count > 0:
		var new_coord := Vector2i(randi_range(0, CHUNK_SIZE/16/2)*2, randi_range(0, CHUNK_SIZE/32/2)*2)
		if not tree_coords.has(new_coord):
			tree_count -= 1
			tree_coords.append(new_coord)
	
	for tree_coord in tree_coords:
		var coord := Vector2i(chunk.x * CHUNK_SIZE / 16 + tree_coord.x, chunk.y * CHUNK_SIZE / 16 + tree_coord.y)
		TreeMap.set_cell(TREE_LAYER, coord, TREE_SOURCE, TREE_POOL.pick_random())
	
	#for i in range(CHUNK_SIZE/16):
		#for j in range(CHUNK_SIZE/16/2):
			#if randi_range(0, 100) <= 1:
				#var tree_coord := Vector2i(chunk.x * CHUNK_SIZE / 16 + i, chunk.y * CHUNK_SIZE / 16 + j * 2)
				#TreeMap.set_cell(TREE_LAYER, tree_coord, TREE_SOURCE, TREE_POOL.pick_random())
