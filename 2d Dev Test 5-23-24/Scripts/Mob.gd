extends CharacterBody2D
class_name mob
@onready var player = preload("res://Scenes/player.tscn")
@onready var main = get_node("/root/Node2D/")
@onready var part = preload("res://Scenes/death_explosion.tscn")
@export var speed = 500
var dead = false
var tracking = false
var playing_hurt = false
signal attack
signal slime_died
	
func _physics_process(delta):
	if tracking == true and dead == false and global_position.distance_to(player.global_position) >= 60:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()




func _on_area_2d_body_entered(body):
	if body == player:
		tracking = true
		


func _on_area_2d_body_exited(body):
	if body == player:
		tracking = false



func _on_health_system_dead():
	dead = true
	part.instantiate()
	queue_free()



func _on_health_system_damaged():
	playing_hurt = true
	$hurt_timer.start()

func _on_hurt_timer_timeout():
	playing_hurt = false

