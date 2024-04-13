extends Node2D
class_name Enemies

export(PackedScene) var enemy_1
export(NodePath) var target
export(NodePath) var health

onready var spawn_curve: Curve2D = $spawn.curve
var target_pos = Vector2.ZERO
var enemies = []
var health_bar:TextureProgress
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	target_pos =  get_node(target).global_position
	health_bar = get_node(health)
	
	Globals.enemies = self

func spawn():
	var enemy:Node2D = enemy_1.instance()	
	add_child(enemy)
	enemy.position = spawn_curve.interpolate_baked(rand_range(0, spawn_curve.get_baked_length()))
	enemy.move_direction = (target_pos - enemy.global_position).normalized()
	enemy.look_at(target_pos)
	enemies.append(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
		

func remove_enemy(enemy):
	if is_instance_valid(enemy):
		enemies.erase(enemy)
		enemy.queue_free()
		
func _on_hit_area_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var parent = area.get_parent()
	if parent.has_method("is_enemy") and parent.is_enemy():
		health_bar.value -= 20
		remove_enemy(parent)

func _on_Enemy1Timer_timeout():
	spawn()
