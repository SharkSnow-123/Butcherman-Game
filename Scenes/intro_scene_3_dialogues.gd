extends Node2D

@onready var this_panel = $Panel
@onready var this_label = $Panel/StoryText


func _ready():
	TransitionScreen.fade_in()
	MusicPlayer.play_music("res://Music/sonic-exe-laugh.mp3")
	
	
