extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var enemies:Enemies

var GlyphVis

var is_casting:bool = false

var game
var pentegram:Node2D

var banished_enemies = 0

var endless_mode:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
