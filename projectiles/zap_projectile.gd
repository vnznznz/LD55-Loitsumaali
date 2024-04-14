extends Node2D


var direction = Vector2.ZERO
var speed = 150
var target_node

# Called when the node enters the scene tree for the first time.
func _ready():
	var selected_distance = INF
	var selected_enemy = null
	for enemy in Globals.enemies.enemies:
		if not is_instance_valid(enemy):
			continue
		var distance = global_position.distance_squared_to(enemy.global_position)
		if distance < selected_distance:
			selected_enemy = enemy
			selected_distance = distance
			target_node = selected_enemy	
			
	if target_node:		
		look_at(selected_enemy.global_position)
		direction = (selected_enemy.global_position - global_position).normalized()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(target_node):		
		look_at(target_node.global_position)
		direction = (target_node.global_position - global_position).normalized()
		
	self.position += direction * speed * delta


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var parent = area.get_parent()
	if parent.has_method("is_enemy") and parent.is_enemy():
		parent.take_damage()
		
		queue_free()


func _on_Timer_timeout():
	queue_free() # Replace with function body.
