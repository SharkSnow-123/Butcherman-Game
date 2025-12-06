extends Node2D

@onready var this_panel = $Panel
@onready var this_label = $Panel/StoryText
@onready var button = $Intro2_ContButton

var scene_dialogues = [
	"So, how exactly did I get here…?",
	"??? : Feeling comfy?"
]

func _ready():
	TransitionScreen.fade_in()
	button.visible = false
	
	await DialogueManager.line_player(scene_dialogues, this_panel, this_label)
	
	if is_instance_valid(button):
		button.visible = true
	
