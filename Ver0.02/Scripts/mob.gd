extends CharacterBody2D
class_name enemy


@onready var tilemap = get_node("/root/Node2D/TileMap")
@onready var player = get_node("/root/Node2D/TileMap/Player/player")
var tracking : bool = false
var speed = 50


func _physics_process(delta):
	if global_position.distance_to(player.global_position) >= 25:
		var dir = global_position.direction_to(player.global_position)
		velocity += dir * speed * delta
		move_and_slide()
	else:
		velocity.x = move_toward(velocity.x,0,delta)
		velocity.y = move_toward(velocity.y,0,delta)
	$Sprite2D.look_at(player.global_position)
	$Sprite2D.set_rotation($Sprite2D.rotation + deg_to_rad(90))
