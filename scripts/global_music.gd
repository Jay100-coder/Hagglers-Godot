extends Node

var audio_player: AudioStreamPlayer
var main_theme = preload("res://assets/music/8bit-morning.mp3")

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	
	audio_player.bus = "Master" 

func play_track() -> void:
	if audio_player.stream == main_theme and audio_player.playing:
		return
		
	audio_player.stream = main_theme
	audio_player.play()

func stop_music() -> void:
	audio_player.stop()
