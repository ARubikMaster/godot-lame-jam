extends Control

@export var level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in $CanvasLayer/MarginContainer2/HFlowContainer.get_children():
		child.pressed.connect(Callable(self, "play").bind(child.text))

func play(diff):
	GlobalScript.current_diff = diff
	get_tree().change_scene_to_packed(level)
