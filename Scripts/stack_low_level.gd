extends Node
#---- STACK FUNCTIONS ----
class_name stack_low_level

var capacity: int
var data: Array = []
var size: int = 0

func _init(_capacity: int):
	capacity = _capacity
	data.resize(capacity)
	
func push(value):
	if size >= capacity:
		print("STACK OVERFLOW")
		return
	data[size] = value;
	size += 1;
	print("DATA: ", data, " size = ", size);

func pop():
	if size <= 0:
		print("STACK UNDERFLOW");
		return null;
	size -= 1;
	print("DATA: ", data, " size = ", size);
	return data[size];

func is_empty() -> bool:
	return size == 0;

func clear():
	size = 0;
