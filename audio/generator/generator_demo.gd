extends Node

var m:float = 1
@onready var slider1 = $"CenterContainer/Frequency/Frequency1HSlider"
@onready var slider2 = $"CenterContainer/Frequency2/Frequency2HSlider"
@onready var slider3 = $"CenterContainer/Frequency3/Frequency3HSlider"
@onready var slider4 = $"CenterContainer/Frequency4/Frequency4HSlider"
@onready var slider5 = $"CenterContainer/Frequency5/Frequency5HSlider"



# Keep the number of samples per second to mix low, as GDScript is not super fast. Changing for email commit test
var sample_hz := 22050.0
var pulse_hz1 := 440.0
var pulse_hz3 := 440.0
var pulse_hz2 := 110.0
var pulse_hz4 := 500
var pulse_hz5 := 440
var phase1 := 0.0
var phase2 := 0.0
var phase3 := 0.0
var phase4 := 0.0
var phase5 := 0.0

# Actual playback stream, assigned in _ready().
var playback1: AudioStreamPlayback
var playback2: AudioStreamPlayback
var playback3: AudioStreamPlayback
var playback4: AudioStreamPlayback
var playback5: AudioStreamPlayback

func _fill_buffer() -> void:
	var increment1 := pulse_hz1 / sample_hz
	var increment2 := pulse_hz2 / sample_hz
	var increment3 := pulse_hz3 / sample_hz
	var increment4 := pulse_hz4 / sample_hz
	var increment5 := pulse_hz5 / sample_hz

	var to_fill1: int = playback1.get_frames_available()
	var to_fill2: int = playback2.get_frames_available()
	var to_fill3: int = playback3.get_frames_available()
	var to_fill4: int = playback4.get_frames_available()
	var to_fill5: int = playback5.get_frames_available()

	while to_fill1 > 0:
		playback1.push_frame(Vector2.ONE * sin(phase1 * TAU)) # Audio frames are stereo.
		phase1 = fmod(phase1 + increment1, 1.0)
		to_fill1 -= 1

	while to_fill2 > 0:
		playback2.push_frame(Vector2.ONE * sin(phase2 * TAU)) # Audio frames are stereo.
		phase2 = fmod(phase2 + increment2, 1.0)
		to_fill2 -= 1
		
	while to_fill3 > 0:
		playback3.push_frame(Vector2.ONE * sin(phase3 * TAU)) # Audio frames are stereo.
		phase3 = fmod(phase3 + increment3, 1.0)
		to_fill3 -= 1
		
	while to_fill4 > 0:
		playback4.push_frame(Vector2.ONE * sin(phase4 * TAU)) # Audio frames are stereo.
		phase4 = fmod(phase4 + increment4, 1.0)
		to_fill4 -= 1
		
	while to_fill5 > 0:
		playback5.push_frame(Vector2.ONE * sin(phase5 * TAU)) # Audio frames are stereo.
		phase5 = fmod(phase5 + increment5, 1.0)
		to_fill5 -= 1

func _process(_delta: float) -> void:
	_fill_buffer()
	if harmSeries == true :
		%HarmonicLabel.text = "Harmonic Series"
		if pulse_hz2 / 2 != pulse_hz1 :
			pulse_hz2 = (pulse_hz1 * m) + pulse_hz1
			pulse_hz3 = (pulse_hz1 * m) + pulse_hz2
			pulse_hz4 = (pulse_hz1 * m) + pulse_hz3
			pulse_hz5 = (pulse_hz1 * m) + pulse_hz4
		else:
			pass
	elif majChord == true :
		%HarmonicLabel.text = "Major Chord"
		if (pulse_hz4 / pulse_hz1 != 2 || pulse_hz3 / pulse_hz1 != 1.5) :
			pulse_hz2 = pulse_hz1 * 1.25 
			pulse_hz3 = pulse_hz1 * 1.5
			pulse_hz4 = pulse_hz1 * 2
			pulse_hz5 = pulse_hz1 * 2.25
	else:
		%HarmonicLabel.text = "OFF"
		
	slider1.value = pulse_hz1
	slider2.value = pulse_hz2
	slider3.value = pulse_hz3
	slider4.value = pulse_hz4
	slider5.value = pulse_hz5


func _ready() -> void:
	# Setting mix rate is only possible before play().
	$Player.stream.mix_rate = sample_hz
	$Player.play()
	$player2.stream.mix_rate = sample_hz
	$player2.play()
	$player3.stream.mix_rate = sample_hz
	$player3.play()
	$player4.stream.mix_rate =sample_hz
	$player4.play()
	$player5.stream.mix_rate = sample_hz
	$player5.play()
	playback1 = $Player.get_stream_playback()
	playback2 = $player2.get_stream_playback()
	playback3 = $player3.get_stream_playback()
	playback4 = $player4.get_stream_playback()
	playback5 = $player5.get_stream_playback()
	# `_fill_buffer` must be called *after* setting `playback`,
	# as `fill_buffer` uses the `playback` member variable.
	_fill_buffer()


func _on_frequency_h_slider_value_changed(value1: float) -> void:
	%FrequencyLabel1.text = "%d Hz" % value1
	pulse_hz1 = value1
	
func _on_frequency_2h_slider_value_changed(value2: float) -> void:
	%FrequencyLabel2.text = "%d Hz" % value2
	pulse_hz2 = value2

func _on_frequency_3h_slider_value_changed(value2: float) -> void:
	%FrequencyLabel3.text = "%d Hz" % value2
	pulse_hz3 = value2
	
func _on_volume_h_slider_value_changed(value: float) -> void:
	# Use `linear_to_db()` to get a volume slider that matches perceptual human hearing.
	%VolumeLabel.text = "%.2f dB" % linear_to_db(value)
	$Player.volume_db = linear_to_db(value)

func _on_volume_2h_slider_value_changed(value: float) -> void:
	%VolumeLabel2.text = "%.2f dB" % linear_to_db(value)
	$player2.volume_db = linear_to_db(value)


func _on_volume_3h_slider_value_changed(value: float) -> void:
	%VolumeLabel3.text = "%.2f dB" % linear_to_db(value)
	$player3.volume_db = linear_to_db(value)


func _on_freq_1_text_changed(new_text: String) -> void:
	var value1 = float(new_text)
	%FrequencyLabel1.text = "%d Hz" % value1
	pulse_hz1 = value1


func _on_freq_2_text_changed(new_text: String) -> void:
	var value2 = float(new_text)
	%FrequencyLabel2.text = "%d Hz" % value2
	pulse_hz2 = value2



func _on_freq_3_text_changed(new_text: String) -> void:
	var value2 = float(new_text)
	%FrequencyLabel3.text = "%d Hz" % value2
	pulse_hz3 = value2


func _on_freq_4_text_changed(new_text: String) -> void:
	var value1 = float(new_text)
	%FrequencyLabel4.text = "%d Hz" % value1
	pulse_hz4 = value1


func _on_freq_5_text_changed(new_text: String) -> void:
	var value1 = float(new_text)
	%FrequencyLabel5.text = "%d Hz" % value1
	pulse_hz5 = value1

func _on_frequency_4h_slider_value_changed(value1: float) -> void:
	%FrequencyLabel4.text = "%d Hz" % value1
	pulse_hz4 = value1

func _on_frequency_5h_slider_value_changed(value1: float) -> void:
	%FrequencyLabel5.text = "%d Hz" % value1
	pulse_hz5 = value1


func _on_volume_4h_slider_value_changed(value: float) -> void:
	%VolumeLabel4.text = "%.2f dB" % linear_to_db(value)
	$player4.volume_db = linear_to_db(value)

func _on_volume_5h_slider_value_changed(value: float) -> void:
	%VolumeLabel5.text = "%.2f dB" % linear_to_db(value)
	$player5.volume_db = linear_to_db(value)



	

	%HarmonicLabel.text = "ON"

var harmSeries:bool = false
var majChord:bool = false

func _on_harmonic_mode_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		harmSeries = toggled_on
	else:
		harmSeries = toggled_on
		


func _on_button_pressed() -> void:
	pulse_hz1 = 27.5


func _on_m_text_changed(new_text: String) -> void:
	m = float(new_text)


func _on_major_chord_toggle_toggled(toggled_on: bool) -> void:
	majChord = toggled_on
