extends Line2D

@export var shark_scene: PackedScene
var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = randf_range(4.5, 6.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	$Timer.wait_time = randf_range(4.5, 6.5)
	
	var new_shark = shark_scene.instantiate()
	new_shark.direction = direction
	new_shark.global_position.x = (direction.x * 512) * -1
	new_shark.global_position.y = global_position.y
	get_parent().add_child(new_shark)
