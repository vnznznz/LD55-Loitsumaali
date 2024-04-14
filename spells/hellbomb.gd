extends Node2D


# Declare member var		iables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2.ZERO
var speed = 350

var do_charge = true
var charge_time = 3
var color = Color.red

var enemies = []

onready var area = $Area2D
onready var flamebg = $FlameBg
# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()	
	tween.tween_property(self, "speed", speed, 0.5)	
	tween.tween_callback(self, "blast_it")
	tween.tween_property(self, "speed", 0, 1)	
	tween.tween_callback(self, "kill_it")
	
	tween = get_tree().create_tween()
	tween.tween_property(flamebg, "scale", Vector2(5, 5), 1)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func kill_it():
	queue_free()
	for enemy in enemies:
		enemy.remove_shield()
		enemy.take_damage()
		
func blast_it():
	$CPUParticles2D.restart()
	
	

func _physics_process(delta):
	for other_area in area.get_overlapping_areas():
		if other_area.get_parent().has_method("is_enemy") and other_area.get_parent().is_enemy():				
			var enemy = other_area.get_parent()
			enemies.append(enemy)
	
	self.position += direction * delta * speed
