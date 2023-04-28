class_name Bullet
extends Area2D

const SPEED = 150

func _ready():
	get_tree().create_timer(1).timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	var velocity = transform.x * SPEED
	position += velocity * delta


func _on_body_entered(body: Node):
	pass
