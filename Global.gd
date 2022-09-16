extends Node

var hue = 0
var color = Color.from_hsv(hue, 0.5, 0.79, 0.8) 



func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		get_tree().quit()

func _ready():
	randomize()

func _process(delta):
	changeBGColor(delta);
	
	
	
func changeBGColor(delta):
	if hue >= 1:
		hue = 0;
	color = Color.from_hsv(hue, 0.5, 0.9, 1)
	VisualServer.set_default_clear_color(color)
	hue += 0.01 * delta;
