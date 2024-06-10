extends TileMap

@onready var player = preload("res://Scenes/player.tscn")
@onready var mob = preload("res://Scenes/mob.tscn")
@onready var bomb = preload("res://Scenes/bomb.tscn")
@onready var emerald = preload("res://Scenes/emerald.tscn")
@onready var global_script = get_node("/root/GlobalScript")
var player1
@export var rocknoise : NoiseTexture2D
var noise : Noise
var noiseimage : Image
const ROWS = 13
const COLS = 21
var collisionlist : Dictionary = {}
var player_spawned = false
var loaded = false
var emerald_count : int = 0
var emerald_win_count : int
var end_spawned : bool = false
var players_emeralds : int = 0
var gate_pos : Vector2i
var players_total_emerald : int
# Called when the node enters the scene tree for the first time.
func _ready():
	on_level_start()
	

func collected_emerald():
	players_emeralds += 1
	players_total_emerald += 1
	%HUD.update_emeralds(players_total_emerald)
	#print("Players Money: ", players_emeralds)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_spawned == false and loaded:
		player_spawn()
	level_clear_check()
	if end_spawned:
		gate_collision()

func player_slam(player_pos):
	var pos = local_to_map(player_pos)
	for i in 3:
		if i == 0:
			destroy_tile_at(pos + Vector2i(0,1))
		if i == 1:
			destroy_tile_at(pos + Vector2i(0,-1))
		if i == 2:
			destroy_tile_at(pos + Vector2i(1,0))
		if i == 3:
			destroy_tile_at(pos + Vector2i(-1,0))

func destroy_tile_at(location : Vector2i):
	if get_cell_atlas_coords(2, location) == Vector2i(1,0):
		spawning(location)
	if get_cell_atlas_coords(2, location) == Vector2i(2,0):
		var e = emerald.instantiate()
		var global_pos = map_to_local(location)
		e.set_global_position(global_pos)
		%Emeralds.add_child(e)
	erase_cell(2,location)

func l2m(location : Vector2):
	return local_to_map(location)

func player_spawn():
	var cell_position = Vector2i(randi_range(0, COLS), randi_range(0, ROWS))
	var global_pos = Vector2i.ZERO
	global_pos = map_to_local(cell_position)
	if get_cell_tile_data(2, cell_position) == null and player_spawned == false and get_cell_tile_data(0, cell_position) == null:
		var p = player.instantiate()
		p.set_global_position(global_pos)
		%Player.add_child(p)
		print("Player Spawned at: ", cell_position)
		player1 = p
		player_spawned = true

func rock_spawning():
	var row = ROWS
	var col = COLS
	noise = rocknoise.noise
	noise.seed = randi_range(0, 200)
	await rocknoise.changed
	noiseimage = rocknoise.get_image()
	for r in row:
		for c in col:
			var cell_position = Vector2i(c, r)
			var global_pos : Vector2i
			global_pos = map_to_local(cell_position)
			if get_cell_tile_data(1, cell_position) != null and get_cell_tile_data(3, cell_position) == null and cell_position.x != 0 and cell_position.y != 0:
				var rocktilechance = randi_range(0,3)
				var eggtilechance =  randi_range(0,0)
				if noiseimage.get_pixelv(global_pos) == Color.WHITE:
					set_cell(2, cell_position,0,Vector2(0,rocktilechance))
					set_cell(1, cell_position,0,Vector2(0,rocktilechance),1)
				elif noiseimage.get_pixelv(global_pos) == Color.BLACK:
					set_cell(2, cell_position,0,Vector2(2,0))
					set_cell(1, cell_position,0,Vector2(2,0),1)
				elif noiseimage.get_pixelv(global_pos) == Color.RED:
					set_cell(2, cell_position,0,Vector2(1,eggtilechance))
					set_cell(1, cell_position,0,Vector2(1,eggtilechance),1)
	loaded = true
	print("rocks generated")
	wincon()

func spawning(location : Vector2i):
	var global_pos = map_to_local(location)
	var m = mob.instantiate()
	m.set_global_position(global_pos)
	%Mobs.add_child(m)

func tile_look_up(location : Vector2):
	location = local_to_map(location)
	return get_cell_tile_data(1, location)

func player_bomb(location : Vector2i):
	var clocation = local_to_map(location)
	if get_cell_tile_data(2, clocation) == null:
		var b = bomb.instantiate()
		b.set_global_position(map_to_local(clocation))
		%Bombs.add_child(b)

func bomb_explos(location : Vector2):
	var row = ROWS
	var col = COLS
	
	for r in row:
		for c in col:
			var cell_position = Vector2i(c, r)
			var global_pos : Vector2i
			global_pos = map_to_local(cell_position)

func on_level_start():
	rock_spawning()

func explosion_handle(location : Vector2, explosion_radius):
	var cell_size = 8
	location = Vector2(local_to_map(location))
	explosion_radius = explosion_radius * 64
	var explosion_range_squared = explosion_radius * explosion_radius
	for x in range(-int(explosion_radius), int(explosion_radius) + 1):
		for y in range(-int(explosion_radius), int(explosion_radius) + 1):
			var distance_squared = Vector2((x * cell_size), (y * cell_size)).distance_squared_to(location)
			if distance_squared <= explosion_range_squared:
				var tile_pos = location + Vector2(x, y) / cell_size
				if get_cell_tile_data(2, tile_pos) != null:
					destroy_tile_at(tile_pos)

func wincon():
	var row = ROWS
	var col = COLS
	for r in row:
		for c in col:
			var cell_position = Vector2i(c, r)
			var global_pos : Vector2i
			global_pos = map_to_local(cell_position)
			if get_cell_atlas_coords(2, cell_position) == Vector2i(2,0):
				emerald_count += 1

func level_clear_check():
	emerald_win_count = int(emerald_count * 0.75)
	if players_emeralds >= emerald_win_count and emerald_win_count >= 1:
		if end_spawned == false:
			open_level_gate()
			#print("go to gate")

func open_level_gate():
	var cell_position = Vector2i(randi_range(0, COLS), randi_range(0, ROWS))
	var global_pos = Vector2i.ZERO
	global_pos = map_to_local(cell_position)
	print("print gate",cell_position)
	if get_cell_tile_data(2, cell_position) == null and end_spawned == false and get_cell_tile_data(0, cell_position) == null:
		destroy_tile_at(cell_position)
		set_cell(3, cell_position, 0, Vector2(3,0))
		print("players emeralds: ", players_emeralds)
		print("emerald_win_count: ", emerald_win_count)
		print("Gate Spawned at: ", cell_position)
		end_spawned = true
		gate_pos = cell_position
	else:
		print("GATE NOT SPAWNED")
		open_level_gate()

func reset_level():
	
	players_emeralds = 0
	end_spawned = false
	player_spawned = false
	loaded = false
	emerald_win_count = 100
	emerald_count = 0
	player1.set_global_position(Vector2(0,0))

func gate_collision():
	if %Player.get_child(0):
		if local_to_map(%Player.get_child(0).global_position) == gate_pos:
			reset_level()
			get_tree().change_scene_to_file("res://Scenes/Main.tscn")
			%Player.get_child(0).queue_free()
	if Input.is_action_just_pressed("r"):
			reset_level()
			get_tree().change_scene_to_file("res://Scenes/Main.tscn")
			%Player.get_child(0).queue_free()
