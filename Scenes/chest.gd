extends Area2D

var opened: bool = false
@export var closed_texture: Texture2D
@export var opened_texture: Texture2D

var reward_types: Array = ["coins"] #incase there could be more

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = closed_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if not opened and body.is_in_group("player"):
		print("Chest opened")
		opened = true
		$Sprite2D.texture = opened_texture
		
		var reward_type = reward_types.pick_random()
		match  reward_type:
			"coins":
				body.coins += snapped(randi_range(10, 30), 5)
