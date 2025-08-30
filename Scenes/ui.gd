extends Control

var upgrade_elements: Array = ["air capacity", "speed", "reward gain", "magnet"]
var powerup_elements: Array = ["shield", "health"]

var prices: Dictionary = {
	"air capacity": 20,
	"speed": 30,
	"reward gain": 30,
	"magnet": 25,
	"shield": 75,
	"health": 50
	#"luck": 1 (if more chest reward types are gonna be added)
	}
@export var heart_full: Texture2D
@export var heart_empty: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#change progressbar value to player air_left value
	$CanvasLayer/MarginContainerProgress/ProgressBar.value = $"../Player".air_left
	$CanvasLayer/MarginContainerProgress/ProgressBar/Label.text = str(round($"../Player".air_left))
	
	#change label text to meter value
	$CanvasLayer/MarginContainerMLabel/MLabel.text = str($"../Camera2D".meters) + "m"

	#change label text to coins value
	$CanvasLayer/MarginContainerCoinLabel/CoinLabel.text = str($"../Player".coins)

	#change max progressbar value to player max air capacity
	$CanvasLayer/MarginContainerProgress/ProgressBar.max_value = $"../Player".max_air
	
	$CanvasLayer/MarginContainerHealth/VFlowContainer/TextureRect.texture = heart_full if $"../Player".health > 0 else heart_empty
	$CanvasLayer/MarginContainerHealth/VFlowContainer/TextureRect2.texture = heart_full if $"../Player".health > 1 else heart_empty
	$CanvasLayer/MarginContainerHealth/VFlowContainer/TextureRect3.texture = heart_full if $"../Player".health > 2 else heart_empty
	
func upgrade_screen():
	#pause the gameplay
	get_tree().paused = true
	$CanvasLayer/UpgradeScreen.show()
	
	#merge upgrades and powerups array
	var all_elements: Array = upgrade_elements + powerup_elements
	
	#assign random element to each button
	for child in $CanvasLayer/UpgradeScreen/MarginContainerButtons/VFlowContainer.get_children():
		var element = all_elements.pick_random()
		all_elements.erase(element)
		
		var price
		
		if element in upgrade_elements:
			price = prices[element] * $"../Player".upgrade_levels[element]
		
		elif element in powerup_elements:
			price = prices[element]
		
		child.text = element + "\n" + str(price) + " coins"
		
		#call _apply_upgrade with element as argument when button is pressed
		child.pressed.connect(Callable(self, "apply_upgrade").bind(element))
	
func apply_upgrade(upgrade_name):
	if upgrade_name in upgrade_elements:
		var price = prices[upgrade_name] * $"../Player".upgrade_levels[upgrade_name]
		
		if $"../Player".coins >= price:
			match upgrade_name:
				"air capacity":
					$"../Player".max_air += 15
					
				"speed":
					$"../Player".speed += 15
			
			_upgraded(price)
			
		else:
			print("Not enough coins") #add error shake animation here
			
	elif upgrade_name in powerup_elements:
		var price = prices[upgrade_name]
		
		if $"../Player".coins >= price:
			match upgrade_name:
				"health":
					pass
				
				"shield":
					$"../Player".shield = true
			
			_upgraded(price)
	
		else:
			print("Not enough coins") #add error shake animation here
	
	else:
		push_error("upgrade isn't inside any array")
	
func _on_button_pressed():
	#when skip button is pressed:
	_upgraded(0)

func _upgraded(price):
	#subract item price from player coins
	$"../Player".coins -= price
	
	#disconnect all previously connected signals
	for child in $CanvasLayer/UpgradeScreen/MarginContainerButtons/VFlowContainer.get_children():
		child.pressed.disconnect(Callable(self, "apply_upgrade"))
	
	#hide the screen and continue the gameplay
	$CanvasLayer/UpgradeScreen.hide()
	get_tree().paused = false
	$"../Camera2D".meters += 2
