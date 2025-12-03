extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	#color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	#if anim_name == "fade_to_black":
		#on_transition_finished.emit()
		#animation_player.play("fade_from_black")
	if anim_name == "fade_to_black":
		get_tree().change_scene_to_file(to_scene)
		
##func transition():
	#color_rect.visible = true
	#animation_player.play("fade_to_black")
	
var to_scene
	
func fade_out(scene_name):
	to_scene = scene_name
	animation_player.play("fade_to_black")
	#await animation_player.animation_finished
	
	
func fade_in():
	animation_player.play("fade_from_black")
