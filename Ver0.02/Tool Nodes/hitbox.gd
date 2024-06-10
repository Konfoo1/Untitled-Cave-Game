extends Area2D
class_name HitBox
@onready var player = get_node("/root/Main/player")
@onready var main = get_node("/root/Main/")

var can_hit = true
var attacking = false

@export var attacker : String
@export var from_player : bool
var attacking_player = false
func _on_body_entered(body):
	if body == player:
		attacking_player = true
	elif body is slime:
		pass


func _on_body_exited(body):
	if body == player:
		attacking_player = false

func _process(delta):
	if can_hit and attacking and attacking_player:
		can_hit = false
		$hitcooldown.start()
		if from_player:
			pass
		else:
			main.damage_player(attacker)
		

func _on_hitcooldown_timeout():
	can_hit = true

func _on_area_entered(area):
	if area is Hurtbox:
		attacking = true



func _on_area_exited(area):
	if area is Hurtbox:
		attacking = false
