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

var attack_idx = 0
var wave_idx = 0

var difficulty_modifier = 0

var attacks = [	
	[
		{
			"total": 5,
			"shield": 0,			
			"deploy": 0.5,			
		},
		{
			"total": 10,
			"shield": 0,
			"deploy": 1.5,
			"prepare": 2,
		},
		{
			"total": 10,
			"shield": 0.7,
			"deploy": 2,
			"prepare": 3,
		},
		{
			"total": 15,
			"shield": 0.3,
			"deploy": 0.2,
		},		
		{
			"total": 30,
			"shield": 0.7,
			"deploy": 10,
			"prepare": 4,
		}
	],
	[
		{
			"total": 10,
			"shield": 0.5,
			"speed_shield": 1,
			"deploy": 10,
		},
		{
			"total": 20,
			"shield": 0,
			"speed_shield": 0.5,
			"deploy": 10,			
		},
		{
			"total": 20,
			"shield": 0.5,
			"speed_shield": 0.1,
			"deploy": 5,
			"prepare": 2,
		},		
		{
			"total": 15,
			"shield": 1,
			"speed_shield": 0.3,
			"deploy": 0.1,
			"prepare": 0,
		},
		{
			"total": 20,
			"shield": 1,
			"speed_shield": 0.4,
			"deploy": 0.1,
			"prepare": 0.5,
		},
		{
			"total": 100,
			"shield": 0.3,
			"speed_shield": 0.2,
			"deploy": 10,
			"prepare": 4
		},
	]
]


const STATE_DEPLOYING = "deploying"
const STATE_WAITING = "waiting"
const STATE_PREPARING = "preparing"

var current_state = STATE_DEPLOYING
var current_enemies_left = 0

var prepare_time_left = 0

onready var assault_label = $AssaultLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	target_pos =  get_node(target).global_position
	health_bar = get_node(health)
	
	Globals.enemies = self
	
	setup_wave()
	
	
func spawn():
	var enemy:Node2D = enemy_1.instance()	
	
	
	add_child(enemy)
	enemy.position = spawn_curve.interpolate_baked(rand_range(0, spawn_curve.get_baked_length()))
	enemy.move_direction = (target_pos - enemy.global_position).normalized()
	
	enemy.look_at(target_pos)
	enemies.append(enemy)
	
	yield(get_tree(), "idle_frame")

	enemy.shield.visible =  attacks[attack_idx][wave_idx]["shield"] >  (1 - randf())
	enemy.speed_shield.visible =  attacks[attack_idx][wave_idx].get("speed_shield", 0) >  (1 - randf())


func setup_wave():
	current_state = STATE_DEPLOYING
	current_enemies_left = attacks[attack_idx][wave_idx]["total"] 
	current_enemies_left *= 1 + (difficulty_modifier * 0.5)
	
	$Enemy1Timer.wait_time = attacks[attack_idx][wave_idx]["deploy"] / float(current_enemies_left)
	$Enemy1Timer.start()
	
	
func deploy_enemy():
	if current_enemies_left > 0:
		spawn()
		current_enemies_left -= 1
	else:
		current_state = STATE_WAITING
		$Enemy1Timer.stop()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state == STATE_WAITING:
		if len(enemies) == 0:
			wave_idx += 1
			if wave_idx >= len(attacks[attack_idx]):
				attack_idx += 1
				wave_idx = 0
				if attack_idx >= len(attacks):
					if Globals.endless_mode:
						attack_idx = 0						
						assault_label.visible = true
						assault_label.text = "Loop %s completed" % [difficulty_modifier]
						var tween = get_tree().create_tween()
						tween.tween_callback(assault_label, "set_visible", [false]).set_delay(3)
						difficulty_modifier += 1
					else:
						Globals.game.set_victory()
					return
				else:
					assault_label.visible = true
					assault_label.text = "Assault %s defended" % [attack_idx]
					var tween = get_tree().create_tween()
					tween.tween_callback(assault_label, "set_visible", [false]).set_delay(3)
					
			current_state = STATE_PREPARING
			prepare_time_left = attacks[attack_idx][wave_idx].get("prepare", 0)
	elif current_state == STATE_PREPARING:
		prepare_time_left -= delta
		if prepare_time_left <= 0:
			setup_wave()
	
		

func remove_enemy(enemy, no_score=false):
	if no_score == true:
		pass
	else:
		Globals.banished_enemies += 1
		
	if is_instance_valid(enemy):
		enemies.erase(enemy)
		enemy.queue_free()
		
func _on_hit_area_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var parent = area.get_parent()
	if parent.has_method("is_enemy") and parent.is_enemy():
		health_bar.value -= 10
		remove_enemy(parent)
		if health_bar.value <= 0:
			Globals.game.set_defeat()

func _on_Enemy1Timer_timeout():
	deploy_enemy()

