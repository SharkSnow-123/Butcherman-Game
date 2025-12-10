extends Node2D

func _on_losttomain_pressed() -> void:
	TransitionScreen.fade_out("res://Scenes/main.tscn")
	
func _ready() -> void:
	MusicPlayer.play_music("res://Music/Eddie Gluskin-Chase theme.mp3")
	
