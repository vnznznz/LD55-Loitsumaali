extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var projectile = preload("res://projectiles/zap_projectile.tscn")
var shot_count = 4
var current_shots = 0

func _ready():
	shoot()

func _process(delta):
	pass
		

func shoot():
	current_shots += 1
	get_parent().add_child(projectile.instance())

func _on_Timer_timeout():
	shoot()
	if current_shots > shot_count:
		queue_free()
