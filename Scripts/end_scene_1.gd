extends Node2D

func _on_wontomain_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
