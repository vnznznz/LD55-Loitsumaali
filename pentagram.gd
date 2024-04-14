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
var spell_instance:Node

var current_spell = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	invocation_bar = get_node(invocation)


	
func push_glyph(glyph, source_node:Node2D):
	if current_glyphs.size() == 0:
		invocation_bar.text = ""
		# Globals.GlyphVis.clear()
	
	Globals.GlyphVis.add_glyph(glyph, global_position)
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
				Globals.GlyphVis.present_sucess()
				return
	
	print("candidates:", candidates)
	if candidates.size() == 0:
		Globals.GlyphVis.present_fail()
		invocation_bar.text += " ?"
		current_glyphs.clear()

func start_casting(spell):
	print("start casting:", spell)
	invocation_bar.text = "casting: " + invocation_bar.text
	current_spell = spell
	spell_instance = spells[spell].instance()
	if spell_instance.do_charge:
		Globals.is_casting = true
		$CastChargeTimer.wait_time = spell_instance.charge_time
		cast_particles_direction.lifetime = spell_instance.charge_time		
		cast_particles_direction.restart()
		cast_particles_direction.modulate = spell_instance.color
		$CastChargeTimer.start()
	else:
		cast_spell(spell)
	
func cast_spell(spell):
	Globals.is_casting = false 
	
	current_glyphs.clear()
	
	print("casting:", spell)
	cast_particles.modulate = spell_instance.color
	cast_particles.restart()
	
	spell_instance.direction =  Vector2(get_local_mouse_position().x, -50).normalized()
	add_child(spell_instance)
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.is_casting:
		update()

func _draw():
	if Globals.is_casting and is_instance_valid(spell_instance):
		draw_line(Vector2.ZERO, Vector2(get_local_mouse_position().x, -50).normalized() * 200, spell_instance.color, 4, true)


func _on_CastChargeTimer_timeout():
	if Globals.is_casting:
		cast_spell(current_spell)
