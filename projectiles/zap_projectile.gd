extends Node2D


var direction = Vector2.ZERO
var speed = 100

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
			
	if selected_enemy:
		look_at(selected_enemy.global_position)
		direction = (selected_enemy.global_position - global_position).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += direction * speed * delta


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var parent = area.get_parent()
	if parent.has_method("is_enemy") and parent.is_enemy():	
		Globals.enemies.remove_enemy(parent)
		queue_free()


func _on_Timer_timeout():
	queue_free() # Replace with function body.
