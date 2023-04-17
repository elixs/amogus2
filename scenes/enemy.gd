class_name Enemy

extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") / 10

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func take_damage():
	print("auch")
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE
