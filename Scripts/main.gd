extends Node2D

func _on_quit_button_pressed():
	get_tree().quit()
	$AudioStreamPlayer.play()

func _on_play_button_pressed():
	TransitionScreen.fade_out("res://Scenes/IntroScene1.tscn")
	$AudioStreamPlayer.play()
	

func _on_texture_button_pressed() -> void:
	MusicPlayer.set_playing(!MusicPlayer.is_playing())

func _ready() -> void:
	MusicPlayer.play_music("res://Music/Menu Music.wav")
	TransitionScreen.fade_in()
	
