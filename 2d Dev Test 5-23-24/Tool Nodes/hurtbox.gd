extends Area2D
class_name Hurtbox
var can_get_hurt = true
@export var health_system : HealthSystem
func _ready():
	
	pass
func dead():
	set_collision_layer_value(1,false)
	
func alive():
		set_collision_layer_value(1,true)

func damage(amount):
	if health_system and can_get_hurt:
		health_system.take_damage(amount)
		can_get_hurt = false
		$hurt_timer.start()



func _on_area_entered(area):
	if area.get_parent() is bullet:
		damage(10)


func _on_hurt_timer_timeout():
	can_get_hurt = true
