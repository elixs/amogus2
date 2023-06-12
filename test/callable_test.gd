extends Node2D

@onready var callable_child: Node2D = $CallableChild


func _ready() -> void:
#	set("_test", _test2)
#	call("_test")
	callable_child.set("_test2", 123123)
#	_test2()
#	callable_child.call("_test2")
	print(callable_child._test2)
#	print(_test2)
#	print(_test3)
	
	
	pass


func _test2():
	print("123")


func _test3():
	print("sadfsadf")
