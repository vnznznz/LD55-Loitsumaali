extends Node2D


# Declare member variables here. Examples:
var speed = 20
var move_direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_enemy():
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += move_direction * delta * speed
	#self.look_at(get_global_mouse_position())
