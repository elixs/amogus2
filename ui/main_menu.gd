extends MarginContainer

@onready var play = %Play
@onready var exit = %Exit

@export var main_scene: PackedScene


func _ready():
	play.pressed.connect(_on_play_pressed)
	exit.pressed.connect(_on_exit_pressed)


func _on_play_pressed():
#	get_tree().change_scene_to_file("res://scenes/main.tscn")
#	get_tree().change_scene_to_packed(main_scene)
	LevelManager.next_level()


func _on_exit_pressed():
	get_tree().quit()
