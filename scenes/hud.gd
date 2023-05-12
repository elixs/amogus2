extends MarginContainer


@onready var progress_bar = $ProgressBar
@onready var jumps = $Jumps
@onready var counter = $Counter


func set_health(value):
	progress_bar.value = value


func set_jumps(value):
	jumps.text = str(value)


func set_counter(value):
	counter.text = str(value)
