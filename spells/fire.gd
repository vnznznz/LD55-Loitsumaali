extends Node2D


# Declare member var		iables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2.ZERO
var speed = 125

var do_charge = true
var charge_time = 2
var color = Color.red

var damage_timers = {}
var damage_timeout = 0.5

onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "speed", 0, 3.5)
	tween.tween_property(self, "speed", 0, 30)
	tween.tween_callback(self, "queue_free")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _physics_process(delta):
	for other_area in area.get_overlapping_areas():
		if other_area.get_parent().has_method("is_enemy") and other_area.get_parent().is_enemy():

				
			var enemy = other_area.get_parent()
			if enemy in damage_timers:
				damage_timers[enemy] -= delta
			else:
				damage_timers[enemy] = damage_timeout
				
			if damage_timers[enemy] <= 0:
				$CPUParticles2D.amount -= 1
				$FlameBg.scale *= 0.9
				
				other_area.get_parent().take_damage()
				damage_timers[enemy] = damage_timeout
				
				if $CPUParticles2D.amount <= 1:
					queue_free()
					return
				
	
	self.position += direction * delta * speed
