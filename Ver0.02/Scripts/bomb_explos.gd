extends Area2D
class_name BombExplos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.get_parent() is Bomb:
		var bomb = area.get_parent()
		bomb.start_explode()
	if area is TileData:
		print(area)
