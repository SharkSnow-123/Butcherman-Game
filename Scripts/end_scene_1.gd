extends Node2D

func _on_wontomain_pressed() -> void:
	TransitionScreen.fade_out("res://Scenes/main.tscn")

func _ready() -> void:
	MusicPlayer.play_music("res://Music/Suspense Pad - Fourpin Sound - SoundLoadMate.com.mp3")


func _on_wontomain_1_pressed() -> void:
	TransitionScreen.fade_out("res://Scenes/main.tscn")
