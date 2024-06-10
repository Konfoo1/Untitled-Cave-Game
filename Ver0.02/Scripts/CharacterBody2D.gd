extends CharacterBody2D
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var tilemap = get_node("/root/Node2D/TileMap")
const SPEED = 50
var friction = 500
var max_speed = 200
var mouse_pos : Vector2i
@export var range = 10
@export var shot_speed = 100
@export var blast_radius = 1
@export var damage = 25
var can_mine = true
var last_dir 
var cur_tile 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var currency : int = 0
var emeralds_collected_this_level : int

func _ready():
	emeralds_collected_this_level = 0
	

func get_emerald_count():
	return emeralds_collected_this_level


func collect_emerald():
	currency += 1
	#print(currency)
	emeralds_collected_this_level += 1
	tilemap.collected_emerald()

func _physics_process(delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	if dir:
		velocity = dir * SPEED
		last_dir = dir
	else:
		velocity.x = move_toward(velocity.x, 0, delta * friction)
		velocity.y = move_toward(velocity.y, 0, delta * friction)
		
	#if cur_tile ==TileData(30500979960):
	#	print("walking on dirt")
	#elif cur_tile == 30752638215:
	#	print("walking on stone")
	#elif cur_tile == 30668752130:
	#	print("walking on gem")
	move_and_slide()

func _process(delta):
	mine()
	place_bomb()
	shoot()
	get_standing_on()
	
	if tilemap.local_to_map(global_position) == tilemap.gate_collision():
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func mine():
	if Input.is_action_just_pressed("ui_accept") and can_mine:
		var pos = global_position
		pos = tilemap.local_to_map(pos)
		pos += mouse_pos
		tilemap.destroy_tile_at(pos)
		can_mine = false
		$MineCooldown.start()

func place_bomb():
	var bomb_pos: Vector2i
	var mouse_position = get_local_mouse_position()
	if Input.is_action_just_pressed("r_click"):
		if mouse_position.x > range or mouse_position.x < -range:
			bomb_pos.x = clamp(mouse_position.x, -range, range) + global_position.x
		else:
			bomb_pos.x = mouse_position.x + global_position.x
		if mouse_position.y > range or mouse_position.y < -range:
			bomb_pos.y = clamp(mouse_position.y, -range, range) + global_position.y
		else:
			bomb_pos.y = mouse_position.y + global_position.y
		tilemap.player_bomb(bomb_pos)

func shoot():
	if Input.is_action_just_pressed("l_click"):
		var b = bullet.instantiate()
		var b_pos = b.get_global_position()
		var m_pos = get_local_mouse_position()
		var rot = b_pos.angle_to_point(m_pos)
		b.set_rotation(rot)
		b.set_global_position(global_position)
		tilemap.add_child(b)
	

func get_standing_on():
	cur_tile = tilemap.tile_look_up(global_position)

#region area mouse click
func _on_top_mouse_entered():
	mouse_pos = Vector2i(0,-1)


func _on_bottom_mouse_entered():
	mouse_pos = Vector2i(0, 1)


func _on_left_mouse_entered():
	mouse_pos = Vector2i(-1,0)


func _on_right_mouse_entered():
	mouse_pos = Vector2i(1,0)


func _on_mine_cooldown_timeout():
	can_mine = true


func _on_self_mouse_entered():
	mouse_pos = Vector2i(0,0)


#endregion
