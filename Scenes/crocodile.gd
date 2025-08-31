extends Area2D

@export var speed: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += Vector2.UP * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player") and not body.invincible:
		body.take_damage()

func _on_timer_timeout():
	queue_free()
