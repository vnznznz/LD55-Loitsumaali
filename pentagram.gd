extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var invocation

onready var cast_particles:CPUParticles2D = get_node("CastParticles")
onready var cast_particles_direction:CPUParticles2D = get_node("CastDirectionParticles")
var invocation_bar:Label

var spells = {
	"|--": preload("res://spells/zap.tscn"),
	"^v-": preload("res://spells/zap.tscn"),
	"^^-": preload("res://spells/zap.tscn"),
	"^v^": preload("res://spells/zap.tscn")
	
}

var current_glyphs = []

var is_casting = false;
var current_spell = ""
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
				start_casting(spell)
				return
	
	print("candidates:", candidates)
	if candidates.size() == 0:
		invocation_bar.text += " ?"
		current_glyphs.clear()

func start_casting(spell):
	print("start casting:", spell)
	invocation_bar.text = "casting: " + invocation_bar.text
	current_spell = spell
	is_casting = true
	cast_particles_direction.restart()
	$CastChargeTimer.start()
	
func cast_spell(spell):
	is_casting = false 
	
	current_glyphs.clear()
	
	print("casting:", spell)
	cast_particles.restart()
	var spell_instance =  spells[spell].instance()
	spell_instance.direction =  Vector2(get_local_mouse_position().x, -50).normalized()
	add_child(spell_instance)
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_casting:
		update()

func _draw():
	if is_casting:
		draw_line(Vector2.ZERO, Vector2(get_local_mouse_position().x, -50).normalized() * 200, Color.whitesmoke, 2, true)


func _on_CastChargeTimer_timeout():
	if is_casting:
		cast_spell(current_spell)
