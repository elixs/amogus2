extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -100.0
const ACCELERATION = 1000
const GRAVITY = 200


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)
	
	move_and_slide()

