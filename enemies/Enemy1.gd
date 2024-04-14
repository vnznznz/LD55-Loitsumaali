extends Node2D


# Declare member variables here. Examples:
var speed = 15
var move_direction = Vector2.ZERO
var shield_visible = false


onready var shield = $Sprite/EnemyShield
onready var speed_shield = $Sprite/SpeedShield

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

func push(delta):
	if speed_shield.visible:
		global_position += Vector2.UP * 25 * delta
		return
		
	if shield.visible:
		remove_shield()
		global_position += Vector2.UP * 50 * delta
	else:
		global_position += Vector2.UP * 50 * delta
	look_at(Globals.pentegram.global_position)
	move_direction = (Globals.pentegram.global_position - self.global_position).normalized()
	
func remove_shield():
	shield.visible = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if speed_shield.visible:
		self.position += move_direction * delta * speed * 2
	else:
		self.position += move_direction * delta * speed
	
	# prevent enemies from going off map
	if self.position.y > 800:
		Globals.enemies.remove_enemy(self, true)
	#self.look_at(get_global_mouse_position())
