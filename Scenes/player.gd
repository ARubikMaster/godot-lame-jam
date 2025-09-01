extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 600.0
@export var friction: float = 800.0

var air_left: float = 100.0
var max_air: float = 100.0
var magnet_strength: int = 0
var coins: int = 0

var shield: bool = false
var health: int = 3
var invincible: bool = false

var checked: bool = false

var upgrade_levels: Dictionary = {
	"max Air": 1,
	"speed": 1,
	"fortune": 1,
	"magnet": 1
}

func _process(delta):
	if GlobalScript.GameOver == true:
		return
		
	$shield_placeholder.visible = shield
	
	# decrease air left
	air_left -= 5.0 * delta
	
	# game over if no air
	if air_left <= 0.0 and not checked:
		$"../Camera2D".start_shake(10, 0.25)
		$"../UI"._game_over($"../Camera2D".meters)
		$"../DamageSFX".play()
		health = 0
		checked = true
	
	#smooth acceleration movement
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	
	if input_dir != Vector2.ZERO:
		# accelerate towards target velocity
		var target_velocity = input_dir * speed
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		# apply friction
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()

func take_damage():
	$"../Camera2D".start_shake(10, 0.25)
	$"../DamageSFX".play()
	
	if not shield:
		health -= 1
	else:
		shield = false
		
	invincible = true
		
	if health == 0:
		$"../UI"._game_over($"../Camera2D".meters)
		return
	
	$InvincibleTimer.start()
	invincible_fx()

func invincible_fx():
	for i in range(6):
		$AnimatedSprite2D.material.set_shader_parameter("active", true)
		await get_tree().create_timer(0.25, false).timeout
		$AnimatedSprite2D.material.set_shader_parameter("active", false)
		await get_tree().create_timer(0.25, false).timeout

func _on_invincible_timer_timeout():
	invincible = false
