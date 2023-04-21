extends MarginContainer


@onready var progress_bar = $ProgressBar
@onready var jumps = $Jumps


func set_health(value):
	progress_bar.value = value


func set_jumps(value):
	jumps.text = str(value)
