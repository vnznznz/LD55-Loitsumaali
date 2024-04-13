extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var invocation

var invocation_bar:Label

var spells = {
	"|--": preload("res://spells/zap.tscn"),
	"^v-": preload("res://spells/zap.tscn"),
	"^^-": preload("res://spells/zap.tscn"),
	"^v^": preload("res://spells/zap.tscn")
	
}

var current_glyphs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	invocation_bar = get_node(invocation)

func push_glyph(glyph, source_node:Node2D):
	if current_glyphs.size() == 0:
		invocation_bar.text = ""
		
	current_glyphs.append(glyph)	
	
	var invocation =  "".join(current_glyphs)
	var candidates = []
	invocation_bar.text = " ".join(current_glyphs)
	
	print("invocation:", invocation)
	for spell in spells.keys():
		if spell.begins_with(invocation):
			candidates.append(spell)
			
			if spell == invocation:
				cast_spell(spell)
				return
	
	print("candidates:", candidates)
	if candidates.size() == 0:
		invocation_bar.text += " ?"
		current_glyphs.clear()

		
func cast_spell(spell):
	current_glyphs.clear()
	
	print("casting:", spell)
	add_child(spells[spell].instance())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
