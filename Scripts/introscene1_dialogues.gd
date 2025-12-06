extends Node2D

@onready var this_panel = $Panel
@onready var this_label = $Panel/StoryText
@onready var button = $Intro1_ContButton

var scene_dialogues = [
	"Ugh, I cannot move...",
	"How did I get here...?",
	"The last time I remember is when I was catching up with a friend, asking how he has been and all since we have not met since college.",
]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TransitionScreen.fade_in()
	button.visible = false
	
	await DialogueManager.line_player(scene_dialogues, this_panel, this_label)
	
	if is_instance_valid(button):
		button.visible = true
	



func _on_intro_1_cont_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/IntroScene2.tscn")
