extends Control

var upgrade_elements: Array = ["max Air", "speed", "fortune", "magnet"]
var powerup_elements: Array = ["shield", "health"]

var can_pause: bool = true

var prices: Dictionary = {
	"max Air": 20,
	"speed": 30,
	"fortune": 30,
	"magnet": 25,
	"shield": 75,
	"health": 50
}

var upgrade_sprites = {
	"max Air": preload("res://Assets/lungs.png"),
	"speed": preload("res://Assets/speed.png"),
	"fortune": preload("res://Assets/chest_closed.png"),
	"magnet": preload("res://Assets/magnet.png"),
	"shield": preload("res://Assets/shield.png"),
	"health": preload("res://Assets/heart_full.png")
}
	
var roman_numerals = {
	1:"I", 2:"II", 3:"III", 4:"IV", 5:"V",
	6:"VI", 7:"VII", 8:"VIII", 9:"IX", 10:"X",
	11:"XI", 12:"XII", 13:"XIII", 14:"XIV", 15:"XV",
	16:"XVI", 17:"XVII", 18:"XVIII", 19:"XIX", 20:"XX",
	21:"XXI", 22:"XXII", 23:"XXIII", 24:"XXIV", 25:"XXV",
	26:"XXVI", 27:"XXVII", 28:"XXVIII", 29:"XXIX", 30:"XXX",
	31:"XXXI", 32:"XXXII", 33:"XXXIII", 34:"XXXIV", 35:"XXXV",
	36:"XXXVI", 37:"XXXVII", 38:"XXXVIII", 39:"XXXIX", 40:"XL",
	41:"XLI", 42:"XLII", 43:"XLIII", 44:"XLIV", 45:"XLV",
	46:"XLVI", 47:"XLVII", 48:"XLVIII", 49:"XLIX", 50:"L"
} # idk if you put the cap so just in case

var button_signals = {}

@export var heart_full: Texture2D
@export var heart_empty: Texture2D

var factor: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalScript.diff == "Easy":
		factor = 0.5
		
	elif GlobalScript.diff == "Hard":
		factor = 2

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
	
	if Input.is_action_just_pressed("pause") and can_pause:
		_pause()

	var bar = $CanvasLayer/MarginContainerProgress/ProgressBar

	var fill_stylebox = bar.get_theme_stylebox("fill")
	if fill_stylebox is StyleBox:
		fill_stylebox.bg_color = Color(0, 155, 255, 0.5)
		bar.add_theme_stylebox_override("fill", fill_stylebox)

	if $"../Player".air_left <= 40:	
		if int($"../Player".air_left) % 2 == 1:
			fill_stylebox = bar.get_theme_stylebox("fill")
			
			if fill_stylebox is StyleBox:
				fill_stylebox.bg_color = Color(1, 0, 0, 0.5)
				bar.add_theme_stylebox_override("fill", fill_stylebox)
	
func upgrade_screen():
	# collect upgrades that are not maxed
	var available_elements: Array = []
	for upgrade in upgrade_elements:
		if $"../Player".upgrade_levels[upgrade] < 5:
			available_elements.append(upgrade)
	
	# collect valid powerups
	for powerup in powerup_elements:
		if powerup == "health" and $"../Player".health >= 3:
			continue
		elif powerup == "shield" and $"../Player".shield:
			continue
		else:
			available_elements.append(powerup)
	
	# filter only affordable
	var affordable_elements: Array = []
	for element in available_elements:
		var price = 0
		
		if element in upgrade_elements:
			price = round(prices[element] * $"../Player".upgrade_levels[element] * factor)
		else:
			price = round(prices[element] * factor)
		
		if $"../Player".coins >= price:
			affordable_elements.append(element)
	
	# skip screen if nothing can be picked
	if affordable_elements.is_empty():
		return
	
	get_tree().paused = true
	can_pause = false
	$CanvasLayer/UpgradeScreen.show()
	$"../Music".bus = "Muffled"
	
	# shuffle and only take 3 max
	affordable_elements.shuffle()
	var children = $CanvasLayer/UpgradeScreen/MarginContainerButtons/VFlowContainer.get_children()
	
	for i in range(children.size()):
		var child = children[i]
		
		if i >= affordable_elements.size() or i >= 3:
			child.hide()
			continue
		else:
			child.show()
		
		var element = affordable_elements[i]
		var price = 0
		if element in upgrade_elements:
			price = round(prices[element] * $"../Player".upgrade_levels[element] * factor)
			
			var level = roman_numerals[$"../Player".upgrade_levels[element]]
			child.text = element + "\nLevel " + level + "\n" + str(price) + " coins"
		else:
			price = round(prices[element] * factor)
			child.text = element + "\n" + str(price) + " coins"
		
		var sprite = child.get_node("Sprite2D")
		if sprite:
			sprite.texture = upgrade_sprites[element]
		
		# reset signals before reusing
		var pressed_callable = Callable(self, "apply_upgrade").bind(element)
		var entered_callable = Callable(self, "_mouse_in").bind(child)
		var exited_callable = Callable(self, "_mouse_out").bind(child)
		
		child.pressed.connect(pressed_callable)
		child.mouse_entered.connect(entered_callable)
		child.mouse_exited.connect(exited_callable)
		
		button_signals[child] = [pressed_callable, entered_callable, exited_callable]
		
		child.pivot_offset = child.get_rect().size / 2
	
func apply_upgrade(upgrade_name):
	if upgrade_name in upgrade_elements:
		var price = prices[upgrade_name] * $"../Player".upgrade_levels[upgrade_name]
		
		if $"../Player".coins >= price:
			match upgrade_name:
				"max Air":
					$"../Player".max_air += 15
					
				"speed":
					$"../Player".speed += 15
			
			_upgraded(price, upgrade_name)
			
		else:
			print("Not enough coins") #add error shake animation here
			
	elif upgrade_name in powerup_elements:
		var price = prices[upgrade_name]
		var upgraded: bool = true
		
		if $"../Player".coins >= price:
			match upgrade_name:
				"health":
					if $"../Player".health < 3:
						$"../Player".health += 1
					
					else:
						upgraded = false
						print("Health full") #add error shake animation here
				
				"shield":
					$"../Player".shield = true
			
			if upgraded:
				_upgraded(price, upgrade_name)
	
		else:
			print("Not enough coins") #add error shake animation here
	
	else:
		push_error("upgrade isn't inside any array")
	
func _on_button_pressed():
	#when skip button is pressed:
	_upgraded(0, null)

func _upgraded(price, upg_name):
	#subract item price from player coins
	can_pause = true
	$"../Player".coins -= price
	
	$"../Music".bus = "Master"
	
	if price != 0:
		$Upg.play()
	
	if upg_name in upgrade_elements:
		$"../Player".upgrade_levels[upg_name] += 1
	
	#disconnect all previously connected signals
	for child in button_signals.keys():
		var cbs = button_signals[child]
		child.pressed.disconnect(cbs[0])
		child.mouse_entered.disconnect(cbs[1])
		child.mouse_exited.disconnect(cbs[2])
	button_signals.clear()
	
	#hide the screen and continue the gameplay
	$CanvasLayer/UpgradeScreen.hide()
	get_tree().paused = false
	$"../Camera2D".meters += 2

func _pause():
	$CanvasLayer/PauseMenu.visible = not $CanvasLayer/PauseMenu.visible
	get_tree().paused = not get_tree().paused
	$"../Music".stream_paused = not $"../Music".stream_paused
	$"../MusicTimer".paused = not $"../MusicTimer".paused
	
func _on_resume_button_pressed():
	_pause()

func _on_back_to_menu_pressed():
	_pause()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _game_over(depth):
	can_pause = false
	GlobalScript.GameOver = true
	
	$"../Player".hide()
	
	if $"../Music":
		$"../Music".stop()
	if $"../MusicTimer":
		$"../MusicTimer".stop()
	
	$CanvasLayer/PauseMenu.visible = false
	$CanvasLayer/GameOver.visible = true
	
	$CanvasLayer/GameOver/MarginContainer3/Label.text = "Depth: " + str(depth)

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func _mouse_in(node):
	var tween = create_tween()
	tween.tween_property(node, "scale", 1.1 * Vector2.ONE, 0.2)

func _mouse_out(node):
	var tween = create_tween()
	tween.tween_property(node, "scale", Vector2.ONE, 0.2)
