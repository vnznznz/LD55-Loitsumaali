extends Node2D

export (NodePath) var detection
var points = []
var rect_points = []
const BOUNDING_SIZE = 100

func _ready():
	detection = get_node(detection)


func _process(delta):
	if Input.is_action_just_pressed("paint"):
		points.clear()
		rect_points.clear()
		
	if Input.is_action_pressed("paint"):
		var draw_point = get_local_mouse_position()
		if abs(draw_point.x) > BOUNDING_SIZE or abs(draw_point.y) > BOUNDING_SIZE:
				pass # outside of painting bounds
		else:
			if points.size() > 0 and points[-1].distance_to(draw_point) < 10:
				pass # ignore close by points
			elif points.size() > 20:
				pass # limit size
			else:
				points.append(draw_point)
				update()
			
	if Input.is_action_just_released("paint"):
		var result = detection.receive_points(points.duplicate())
		if result != null:
				rect_points = result
		update()

func _draw():
	if points.size() > 1:
		draw_polyline(points, Color(0.5, 0, 0), 8)
	if rect_points.size() > 2:
		draw_polyline(rect_points, Color(0.5, 0, 0.5), 2)
	draw_polyline([Vector2(-BOUNDING_SIZE, -BOUNDING_SIZE), Vector2(-BOUNDING_SIZE, BOUNDING_SIZE), Vector2(BOUNDING_SIZE, BOUNDING_SIZE), Vector2(BOUNDING_SIZE, -BOUNDING_SIZE), Vector2(-BOUNDING_SIZE, -BOUNDING_SIZE)], Color(0.9, 0.9, 0.9), 2)
	
	draw_circle(Vector2.ZERO, 2, Color(1, 0.8, 0))
