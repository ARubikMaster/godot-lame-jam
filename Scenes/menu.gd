extends Control

func _process(delta):
	$CanvasLayer/Sprite2D.region_rect.position.y += 10 * delta
	
	if $CanvasLayer/Sprite2D.region_rect.position.y >= 384:
		$CanvasLayer/Sprite2D.region_rect.position.y = 0
	
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Menu loaded!")
	for child in $CanvasLayer/MarginContainer/HFlowContainer.get_children():
		child.pressed.connect(Callable(self, "play").bind(child.text))

func play(diff):
	GlobalScript.current_diff = diff
	get_tree().change_scene_to_file("res://Scenes/level.tscn")
