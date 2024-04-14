extends Node2D


var do_charge = false
var charge_time = 1
var color = Color.gray

var speed = 150

onready var area:Area2D =  $Area2D
# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0), 3)
	tween.tween_callback(self, "queue_free")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _physics_process(delta):
	for other_area in area.get_overlapping_areas():
		if other_area.get_parent().has_method("is_enemy") and other_area.get_parent().is_enemy():
			other_area.get_parent().push(delta) 			
	
	self.global_position += Vector2.UP * speed * delta
