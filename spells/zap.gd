extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var projectile = preload("res://projectiles/zap_projectile.tscn")
var shot_count = 4
var current_shots = 0
var direction = Vector2.ZERO
var speed = 75

var do_charge = true
var charge_time = 1
var color = Color.aqua

func _ready():
	shoot()
	
	

func _process(delta):
	self.position += direction * delta * speed
		

func shoot():
	current_shots += 1
	var proj = projectile.instance()
	
	get_parent().add_child(proj)
	proj.global_position = global_position

func _on_Timer_timeout():
	shoot()
	if current_shots > shot_count:
		queue_free()
