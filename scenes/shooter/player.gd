extends CharacterBody2D

const SPEED = 100
const ACCELERATION = 1000




func _physics_process(delta):
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(move_input * SPEED, ACCELERATION * delta)
	move_and_slide()
