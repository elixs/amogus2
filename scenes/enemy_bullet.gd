extends Bullet


func _on_body_entered(body: Node):
	if body is Enemy:
		return
	if body is Player:
		var player = body as Player
		player.take_damage()
	queue_free()
