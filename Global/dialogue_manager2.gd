extends Node

const TYPE_SPEED = 0.05
const SHOWTIME = 2.0

var type_timer = Timer
var active_label = Label
var active_panel = Panel
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
	
	active_panel.visible = true
	
	for  line in lines:
		await singleLine(line)
	
	active_panel.visible = false

func singleLine(text: String):
	
	active_label.text = ""
	current_text = text
	charIndex = 0
	is_typing = true
	
	type_timer.start()
	
	while is_typing:
		await get_tree().process_frame
	
	await get_tree().create_timer(SHOWTIME).timeout

func typeWriter():
	
	if active_label and charIndex < current_text.length():
		active_label.text += current_text[charIndex]
		charIndex += 1
	else:
		type_timer.stop()
		is_typing = false
	
