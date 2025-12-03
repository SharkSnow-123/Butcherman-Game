extends Node2D

func _on_quit_button_pressed():
	get_tree().quit()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/IntroScene1.tscn")

func _on_texture_button_pressed() -> void:
	MusicPlayer.set_playing(!MusicPlayer.is_playing())

func _ready() -> void:
	MusicPlayer.play_music("res://Music/Menu Music.wav")
	
