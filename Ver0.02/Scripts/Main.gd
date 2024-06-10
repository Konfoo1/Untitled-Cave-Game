extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	new_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_level():
	var chosen_map = randi_range(0,4)
