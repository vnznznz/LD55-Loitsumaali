extends Node2D


# Declare member variables here. Examples:
var speed = 15
var move_direction = Vector2.ZERO
var shield_visible = false

onready var shield = $Sprite/EnemyShield
# Called when the node enters the scene tree for the first time.
func _ready():
	shield.visible = shield_visible

func is_enemy():
	return true

func take_damage():
	if shield.visible:
		shield.visible = false
	else:
		Globals.enemies.remove_enemy(self)

func remove_shield():
	shield.visible = false
	look_at(Globals.pentegram.global_position)
	move_direction = (Globals.pentegram.global_position - self.global_position).normalized()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += move_direction * delta * speed
	
	# prevent enemies from going off map
	if self.position.y > 800:
		Globals.enemies.remove_enemy(self, true)
	#self.look_at(get_global_mouse_position())
