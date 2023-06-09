extends Node

@export var levels: Array[PackedScene]

var level = -1

func next_level():
	if level + 1 < levels.size():
		level += 1
		get_tree().change_scene_to_packed(levels[level])


func retry():
	get_tree().reload_current_scene()
