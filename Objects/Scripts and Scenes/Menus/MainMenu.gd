extends Control

class_name MainMenu

@onready var startButton = $"MarginContainer/VBoxContainer/Buttons vbox/StartButton"
@onready var quitButton = $"MarginContainer/VBoxContainer/Buttons vbox/QuitButton"

var hoveringStart : bool = false
var hoveringQuit : bool = false
var scaleTime : float = 0.0
var sinTime : float = 0.0

func _ready():
	startButton.pivot_offset = Vector2(57, 26)
	quitButton.pivot_offset = Vector2(57, 26)
	
func _process(delta):
	if hoveringStart :
		OscillateButton(startButton, delta)
	if hoveringQuit :
		OscillateButton(quitButton, delta)

func OscillateButton(button : Button, delta : float) :
	scaleTime += delta * 3
	sinTime += delta * 3.2
	# Rotation
	button.rotation_degrees = sin(sinTime)
	# Scaling
	var scaleSin = sin(scaleTime)/8 + 1
	button.scale = Vector2(scaleSin,scaleSin)
	
func _on_start_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	pass # Replace with function body.

func _on_start_button_mouse_entered():
	hoveringStart = true

func _on_start_button_mouse_exited():
	hoveringStart = false
	startButton.rotation_degrees = 0
	startButton.scale = Vector2(1,1)
	scaleTime = 0

func _on_quit_button_mouse_entered():
	hoveringQuit = true

func _on_quit_button_mouse_exited():
	hoveringQuit = false
	quitButton.rotation_degrees = 0
	quitButton.scale = Vector2(1,1)
	scaleTime = 0
