extends Node


@onready var tilemap = get_node("/root/Node2D/TileMap")
var players_emeralds : int
@onready var hud = get_node("/root/Node2D/CanvasLayer/HUD")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_hud(emerald_total):
	players_emeralds += 1
	#hud.update_emeralds(players_emeralds)
