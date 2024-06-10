extends Node2D
class_name Bomb
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var tilemap = get_node("/root/Node2D/TileMap")
@onready var explosion = preload("res://Scenes/explosion.tscn")
@export_range(1,8) var explosion_radius : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.get_parent() is Bullet or area is BombExplos:
		start_explode()


func start_explode():
		$fuse.start()
		$Fuse.emitting = true
		$PointLight2D.enabled = true

func explode():
	$bomb_explos.monitoring = true
	$bomb_explos.monitorable = true
	$Sprite2D.visible = false
	$Area2D.monitorable = false
	$Area2D.monitoring = false
	var ex = explosion.instantiate()
	ex.global_position = global_position
	tilemap.add_child(ex)
	ex.emitting = true
	print(get_parent())
	$delete.start()
	tilemap.explosion_handle(global_position, explosion_radius)


func _on_timer_timeout():
	explode()
	


func _on_delete_timeout():
	queue_free()



