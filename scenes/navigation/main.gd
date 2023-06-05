extends Node2D


@onready var target = $Target

func _physics_process(delta):
	target.global_position = get_global_mouse_position()
