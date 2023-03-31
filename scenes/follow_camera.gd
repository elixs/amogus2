extends Camera2D


func _physics_process(delta):
	var new_position = Vector2.ZERO
	var nodes = get_tree().get_nodes_in_group("camera")
	for node in nodes:
		new_position += node.global_position
	new_position /= nodes.size()
	global_position = new_position
