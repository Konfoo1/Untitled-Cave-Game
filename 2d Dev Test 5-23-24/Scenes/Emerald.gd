extends Node2D
class_name Emerald
@onready var player = get_node("/root/Node2D/TileMap/Player/player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body == player:
		player.collect_emerald()
		queue_free()
