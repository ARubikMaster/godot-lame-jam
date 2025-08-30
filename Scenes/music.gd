extends AudioStreamPlayer

# Music tracks
var tracks = {
	"descent": preload("res://Assets/descent.mp3"),
	"the-deep": preload("res://Assets/the-deep.mp3"),
	"surface": preload("res://Assets/surface.mp3")
}
var last_track = "" # To ensure a track does not play twice

var rng = RandomNumberGenerator.new()

func _ready():
	process_mode = PROCESS_MODE_ALWAYS

# This is called whenever a track is needed to be played
func play_music():
	stop()
	
	var temp = tracks.duplicate()
	
	if last_track != "":
		temp.erase(last_track)
		
	# Select random track
	var keys = temp.keys()
	rng.randomize()
	var random_key = keys[rng.randi_range(0, keys.size() - 1)] # Selects random item from keys

	stream = temp[random_key]
	play()
	
	last_track = random_key

	
	
