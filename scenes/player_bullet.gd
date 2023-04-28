extends Bullet


func _on_body_entered(body: Node):
	if body is Player:
		return
	if body is Enemy:
		var enemy = body as Enemy
		enemy.take_damage()
	queue_free()
