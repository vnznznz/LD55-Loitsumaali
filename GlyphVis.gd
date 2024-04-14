extends Node2D
class_name GlyphVis

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var glyph_textures = {
	"-": preload("res://assets/Glyph_Horizontal.png"),
	"|": preload("res://assets/Glyph_Vertical.png"),
	">": preload("res://assets/Glyph_Right.png"),
	"<": preload("res://assets/Glyph_Left.png"),
	"^": preload("res://assets/Glyph_Up.png"),
	"V": preload("res://assets/Glyph_Down.png"),
}


var current_offset_x = 0 

onready var viz_pos = $VisPos.global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.GlyphVis = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func present_fail():
	current_offset_x = 0 
	for child in get_children():
		var scale_factor = 0.6
		var tween = get_tree().create_tween()
		tween.tween_property(child, "modulate", Color(Color.darkslateblue.r, Color.darkslateblue.g, Color.darkslateblue.b, 0), 0.5)
		tween.tween_callback(child, "queue_free")
		tween = get_tree().create_tween()
		tween.tween_property(child, "global_position", Vector2(child.global_position.x -4000, child.global_position.y), 10)
		
func present_sucess():	
	current_offset_x = 0 
	for child in get_children():
		var scale_factor = 0.6
		var tween = get_tree().create_tween()
		tween.tween_property(child, "modulate", Color.darkgoldenrod, 0.5)
		tween.tween_callback(child, "queue_free")
		
		
func clear():	
	current_offset_x = 0
	for child in get_children():
		child.queue_free()

func add_glyph(glyph, start_pos:Vector2):
	var scale_factor = 0.3
	var target_pos = Vector2(global_position.x + current_offset_x, global_position.y)
	var tex:Texture = glyph_textures[glyph]
	current_offset_x += tex.get_width() * scale_factor
	var sprite = Sprite.new()
	sprite.texture = tex
	sprite.modulate = Color.darkred
	sprite.global_position = viz_pos
	sprite.offset = Vector2(-tex.get_width() / 2.0, -tex.get_height() / 2.0)
	#sprite.centered = true

	add_child(sprite)
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(sprite.modulate.r, sprite.modulate.g, sprite.modulate.b, 0), 1)
	tween.tween_callback(sprite, "queue_free")
	
	var sprite2 = Sprite.new()
	
	sprite2.texture = tex
	sprite2.modulate = Color.darkred
	sprite2.global_position = target_pos
	sprite2.scale = Vector2(scale_factor, scale_factor)
	add_child(sprite2)
	
	
	
