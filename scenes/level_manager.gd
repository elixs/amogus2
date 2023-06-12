extends Node

@export var levels: Array[PackedScene]

@export var game_over: PackedScene
var level = -1

func next_level():
	if level + 1 < levels.size():
		level += 1
		get_tree().change_scene_to_packed(levels[level])
	else:
		if game_over:
			get_tree().change_scene_to_packed(game_over)


func retry():
	get_tree().reload_current_scene()
