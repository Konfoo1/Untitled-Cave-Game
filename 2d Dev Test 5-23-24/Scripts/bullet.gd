extends CharacterBody2D
class_name Bullet
@onready var player = get_node("/root/Node2D/TileMap/Player/player")
@onready var tilemap = get_node("/root/Node2D/TileMap")
@onready var bomb = preload("res://Scenes/bomb.tscn")

var t = Timer.new()
@export var speed : float
var travelled_distance = 0
var range = 75
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
	travelled_distance += speed * delta
	
	if travelled_distance >= range:
		self.queue_free()



func _on_area_2d_body_entered(body):
	if body == bomb or body == tilemap:
		queue_free()
		travelled_distance = range - 2






func _on_area_2d_area_entered(area):
	if (area.get_parent()).get_parent() != player: 
		if area.get_parent() is Bomb:
			queue_free()
		travelled_distance = range - 2
		print(tilemap.local_to_map(area.global_position))

