extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var attack = $AttackLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	attack.text = "%s - %s/%s - %s" % [Globals.enemies.attack_idx + 1, Globals.enemies.wave_idx + 1, len(Globals.enemies.attacks[Globals.enemies.attack_idx]), len(Globals.enemies.enemies) ]
	if Globals.endless_mode:
		attack.text += " - endless"
	if Globals.enemies.difficulty_modifier > 1:
		attack.text += " - loop %s" % [Globals.enemies.difficulty_modifier -1]
