extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var direction = Vector2.ZERO
var speed = 75

var do_charge = true
var charge_time = 2.5
var color = Color.brown

var health = 3

var shoot_timer = 0
var shoot_timeout = 1.5

var bullet = preload("res://projectiles/boulder.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "speed", 0, 4.5)
	tween.tween_callback(self, "queue_free").set_delay(60)
	rotation = direction.angle()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var lookat_tween:SceneTreeTween
var current_closest_enemy

func _physics_process(delta):
	self.position += direction * delta * speed
	
	shoot_timer -= delta
	
	var closest_distance = INF
	var closest_enemy = null
	for other_area in $Area2D_Detection.get_overlapping_areas():			
		if other_area.get_parent().has_method("is_enemy") and other_area.get_parent().is_enemy():				
			var enemy = other_area.get_parent()
			var distance = global_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy
				
	if closest_enemy and closest_enemy != current_closest_enemy:
		current_closest_enemy = closest_enemy
		if is_instance_valid(lookat_tween):
			lookat_tween.kill()
		var rot = self.global_position.angle_to_point(closest_enemy.global_position) - PI
		if rot > TAU:
			rot -= TAU
		
		lookat_tween = get_tree().create_tween()
		lookat_tween.tween_property(self, "rotation", rot, 1)
		
		
	if shoot_timer < 0:
		shoot_timer = 0
		
		if closest_enemy:
			
			shoot_timer = shoot_timeout
			var b = bullet.instance()			
			get_parent().add_child(b)
			b.global_position = global_position
			b.look_at(closest_enemy.global_position)
			b.direction = (closest_enemy.global_position - global_position).normalized()

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):	
	var parent = area.get_parent()
	if parent.has_method("is_enemy") and parent.is_enemy():
		parent.take_damage()
		health -= -1
		if health <= 0:
			queue_free()
