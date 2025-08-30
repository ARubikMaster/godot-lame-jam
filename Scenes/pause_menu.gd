extends ColorRect

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused:
			get_tree().paused = false
			visible = false

func handle_pausing():

	if !get_tree().paused:
			visible = true
			get_tree().paused = true
	else:
			get_tree().paused = false
			visible = false


func _on_button_pressed() -> void:
	get_tree().paused = false
	visible = false
