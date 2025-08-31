extends Area2D

var direction: Vector2
@export var speed: int

var move: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.flip_h = direction == Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if move:
		global_position.x += (direction.x * speed * delta)

func _on_timer_timeout():
	move = true

func _on_body_entered(body):
	if body.is_in_group("player") and not body.invincible:
		body.take_damage()
