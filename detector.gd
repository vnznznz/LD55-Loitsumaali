extends Node2D
class_name Detection

export(NodePath) var glyphs
export(NodePath) var pentagram

const SIZE = 64.0
var scaled_points = []
var rect_points = []

var glyph_points = {}
var glyph_nodes = {}
var point_to_glyphs = {}
var selected_glyph_node
var selected_glyph_type

func _ready():
	pentagram = get_node(pentagram)
	for line in get_node(glyphs).get_children():	
		if typeof(line) == typeof(Line2D):			
			glyph_points[line.symbol] = line.points
			glyph_nodes[line.symbol] = line

func _process(delta):
	pass

func are_points_similar(points_a, points_b, threshold, glyph_type, missable_points):
	var threshold_squared = threshold * threshold
	var missed_points = 0
	var similarity = 0
	for point_a in points_a:
		var found = false
		for b_idx in range(points_b.size()):
			var point_b = points_b[b_idx]
			var distance_squared = point_a.distance_squared_to(point_b)
			if distance_squared < threshold_squared:
				similarity += 1 - (distance_squared / threshold_squared)
				found = true
				if point_a in point_to_glyphs:
					point_to_glyphs[point_a].append(glyph_type)
				else:
					point_to_glyphs[point_a] = [glyph_type]
				break
		if not found:
			missed_points += 1
			if missed_points > missable_points:
				return 0
	if missed_points == points_a.size():
		return 0
	return similarity / points_a.size()

func select_glyph(user_points):
	point_to_glyphs.clear()
	#if selected_glyph_node != null:
	#	selected_glyph_node.modulate = Color(1, 1, 1)
	#	selected_glyph_type = null
	var glyph_type_to_similarity = {}
	for glyph_type in glyph_points.keys():
		var target_points = glyph_points[glyph_type]
		var target_node = glyph_nodes[glyph_type]
		glyph_type_to_similarity[glyph_type] = are_points_similar(target_points, user_points.duplicate(), 14, glyph_type, target_node.missable_points)
	var similarity_cutoff = 0.35
	var highest_similarity = similarity_cutoff
	var max_candidates = 2
	var candidates_count = 0
	print(glyph_type_to_similarity)
	for glyph_type in glyph_type_to_similarity.keys():
		if glyph_type_to_similarity[glyph_type] > similarity_cutoff:
			candidates_count += 1
			if glyph_type_to_similarity[glyph_type] > highest_similarity:
				selected_glyph_type = glyph_type
	if candidates_count >= max_candidates:
		print("too many candidates, ignoring")
	elif selected_glyph_type != null:
		selected_glyph_node = glyph_nodes[selected_glyph_type]
		selected_glyph_node.modulate = Color(0, 1, 0)
		pentagram.push_glyph(selected_glyph_type, selected_glyph_node) 

func receive_points(points):
	if selected_glyph_node != null:
		selected_glyph_node.modulate = Color(1, 1, 1)
		selected_glyph_type = null
	if points.size() < 2:
		return []
	scaled_points.clear()
	rect_points.clear()
	var max_x = -INF
	var min_x = INF
	var max_y = -INF
	var min_y = INF
	for point in points:
		if point.x > max_x:
			max_x = point.x
		if point.x < min_x:
			min_x = point.x
		if point.y > max_y:
			max_y = point.y
		if point.y < min_y:
			min_y = point.y
	rect_points.append_array([Vector2(min_x, min_y), Vector2(min_x, max_y), Vector2(max_x, max_y), Vector2(max_x, min_y), Vector2(min_x, min_y)])
	var width = abs(min_x - max_x)
	var height = abs(min_y - max_y)
	
	if width == 0 or height == 0:
		push_warning("invalid shape, width or height = 0")
		return []
	var aspect_ratio_x = SIZE / width
	var aspect_ratio_y = SIZE / height
	var aspect_ratio = min(aspect_ratio_x, aspect_ratio_y)

	for point in points:
		var scaled_x = (point.x - min_x - width / 2.0) * aspect_ratio
		var scaled_y = (point.y - min_y - height / 2.0) * aspect_ratio
		scaled_points.append(Vector2(scaled_x, scaled_y))
	select_glyph(scaled_points)
	update()
	
	return rect_points

func _draw():
	draw_polyline([Vector2(-SIZE / 2.0, -SIZE / 2.0), Vector2(-SIZE / 2.0, SIZE / 2.0), Vector2(SIZE / 2.0, SIZE / 2.0), Vector2(SIZE / 2.0, -SIZE / 2.0), Vector2(-SIZE / 2.0, -SIZE / 2.0)], Color(0.9, 0.9, 0.9), 2)
	draw_circle(Vector2.ZERO, 2, Color(1, 0.8, 0))
	if scaled_points.size() > 2:
		draw_polyline(scaled_points, Color.purple, 4, true)
	if point_to_glyphs.size() > 0:
		for point in point_to_glyphs.keys():
			draw_circle(point, 2, Color(0, 1, 1))
