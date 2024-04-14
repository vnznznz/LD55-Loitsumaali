extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var direction = Vector2.ZERO
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_callback(self, "queue_free").set_delay(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.position += direction * speed * delta

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var parent = area.get_parent()
	if parent.has_method("is_enemy") and parent.is_enemy():
		parent.take_damage()
		
		queue_free()
