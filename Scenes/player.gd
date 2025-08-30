extends CharacterBody2D

@export var speed: int = 100
var air_left: float = 100.0

var max_air: float = 100.0
var magnet_strength: int = 0

var coins: int = 9999

var shield: bool = false

var health = 3

var upgrade_levels: Dictionary = {
	"air capacity": 1,
	"speed": 1,
	"reward gain": 1,
	"magnet": 1
	#"luck": 1 (if more chest reward types are gonna be added)
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$shield_placeholder.visible = shield
	
	#decrease air left
	air_left -= 5.0 * delta
	
	#call game over screen after no air is left
	if air_left <= 0.0:
		get_parent()._game_over()
	
	#move player
	velocity = Input.get_vector("left", "right", "up", "down").normalized() * speed
	
	move_and_slide()
