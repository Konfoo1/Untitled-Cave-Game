extends Control

var players_cur : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_emeralds(players_emeralds):
	players_cur += 1
	%emeralds.set_text("Emeralds: " + str(players_emeralds))
