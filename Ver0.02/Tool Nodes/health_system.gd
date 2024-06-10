extends Node
class_name HealthSystem

@export var health = 0
@export var starting_health = 100
@export var max_health = 200
signal dead
signal healed
signal damaged

func take_damage(amount):
	health -= amount
	health = max(0, health)
	emit_signal("damaged")
	if health == 0:
		emit_signal("dead")


func heal(amount):
	health += amount
	health = min(health, max_health)
	emit_signal("healed")


func _ready():
	health = starting_health
