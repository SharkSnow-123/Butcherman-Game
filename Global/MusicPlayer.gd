## NAME THIS FILE MusicPlayer.gd or sumthn
## PUT THIS FILE IN GLOBALS

extends AudioStreamPlayer

var current_pos: float = 0;
func play_music(file_name:String)->void:
	if file_name.is_empty():
		printerr("File name is empty")
	else:
		stream = load(file_name);
		play()

func pause_music()->void:
	if stream != null:
		current_pos = get_playback_position()
		stop()

func continue_music()->void:
	if stream != null:
		play(current_pos)
