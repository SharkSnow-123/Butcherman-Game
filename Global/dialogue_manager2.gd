extends Node

const TYPE_SPEED = 0.05
const SHOWTIME = 2.0

var type_timer: Timer # changed
var active_label: Label = null# changed
var active_panel: Panel = null # changed
var current_text: String = ""
var charIndex: int = 0
var is_typing: bool = false

func _ready() -> void:
	
	type_timer = Timer.new()
	add_child(type_timer)
	type_timer.wait_time = TYPE_SPEED
	type_timer.timeout.connect(typeWriter)
	

func  line_player(lines: Array, target_panel: Panel, target_label: Label):
	
	active_panel = target_panel
	active_label = target_label
	
	if not is_instance_valid(active_panel) or not is_instance_valid(active_label): # added
		return
		
	active_panel.visible = true
	
	for  line in lines:
		await singleLine(line)
	
	if is_instance_valid(active_panel):
		active_panel.visible = false

func singleLine(text: String):
	
	if not is_instance_valid(active_label): # added
		is_typing = false
		return  
	
	active_label.text = ""
	current_text = text
	charIndex = 0
	is_typing = true
	
	type_timer.start()
	
	while is_typing: # fixed
		await get_tree().process_frame
	
	await get_tree().create_timer(SHOWTIME).timeout

func typeWriter():
	
	if not is_instance_valid(active_label):
		type_timer.stop()
		is_typing = false
		return
	
	if charIndex < current_text.length(): # fixed
		active_label.text += current_text[charIndex]
		charIndex += 1
	else:
		type_timer.stop()
		is_typing = false
	
func stop_dialogue(): # new func
	is_typing = false
	if type_timer:
		type_timer.stop()
