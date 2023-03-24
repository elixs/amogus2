extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -100.0
const ACCELERATION = 100
const GRAVITY = 200

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot = $Pivot

func _physics_process(delta):
	if not is_on_floor():
		velocity
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)
	
	move_and_slide()
	
	# animation
	
	if abs(velocity.x) > 10 or move_input:
		playback.travel("run")
	else:
		playback.travel("idle")
	
	if move_input:
		pivot.scale.x = sign(move_input)
