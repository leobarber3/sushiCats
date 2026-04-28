extends CanvasLayer

signal start_game # once start game is ready 
signal next_level # go to next level
signal try_again # try the level again
signal reset_level # reset level back to first
#@export var round : int = 0 not even using this variable??

# Different Screens
@onready var home_screen = $ScreenManager/HomeScreen
@onready var gameplay_screen = $ScreenManager/GameplayScreen
@onready var level_complete_screen = $ScreenManager/LevelCompleteScreen
@onready var game_over_screen = $ScreenManager/GameOverScreen
@onready var last_level_screen = $ScreenManager/LastLevelScreen
@onready var recipe_book_screen = $ScreenManager/RecipeBookScreen
@onready var how_to_play_screen = $ScreenManager/HowToPlayScreen
@onready var how_to_play_screen_two = $ScreenManager/HowToPlayScreen2
# Nodes in Home Screen
@onready var home_title = $ScreenManager/HomeScreen/TitleText

# Nodes in Gameplay Screen
@onready var score_label = $ScreenManager/GameplayScreen/ScoreLabel
@onready var level_label = $ScreenManager/GameplayScreen/LevelLabel
@onready var progress_bar = $ScreenManager/GameplayScreen/ProgressBar
@onready var quick_label = $ScreenManager/GameplayScreen/QuickLabel
@onready var text_timer = $ScreenManager/GameplayScreen/textTimer

# Nodes in LevelComplete Screen
@onready var level_title = $ScreenManager/LevelCompleteScreen/TitleText
# optional text in case we want to speed up cat spawn timers or something!
# or even change game timer!
@onready var optional_text = $ScreenManager/LevelCompleteScreen/OptionalText
@onready var unlocked_ingredients_container = $ScreenManager/LevelCompleteScreen/NewRecipeBoard/IngredientsUnlocked
@onready var food_unlocked = $ScreenManager/LevelCompleteScreen/FoodUnlocked
# Nodes in GameOver Screen
@onready var game_text = $ScreenManager/GameOverScreen/GameText

#Nodes in Recipe Book Screen 
@onready var recipe_container = $ScreenManager/RecipeBookScreen/RecipeBookPanel/RecipeBookScroll/RecipeBookContainer
@export var recipe_book_slot : PackedScene

func show_home():	
	home_screen.show()
	gameplay_screen.hide()
	level_complete_screen.hide()
	game_over_screen.hide()
	last_level_screen.hide()
	recipe_book_screen.hide()
	how_to_play_screen.hide()
	$BackgroundMusic.stop()
	
func show_gameplay():
	home_screen.hide()
	gameplay_screen.show()
	level_complete_screen.hide()
	game_over_screen.hide()
	last_level_screen.hide()
	recipe_book_screen.hide()
	$BackgroundMusic.play()

func show_level_complete(level : int, new_recipe : Array[Item], optional : String):
	level_title.text = "Level " + str(level) + " complete!"
	# Hide the next level button if it's the last level, display if not
	optional_text.text = optional
	display_unlocked_recipe(level, new_recipe)
	#update_recipe_book(recipe_book)
	home_screen.hide()
	gameplay_screen.hide()
	level_complete_screen.show()
	game_over_screen.hide()
	last_level_screen.hide()
	recipe_book_screen.hide()
	$BackgroundMusic.stop()

func show_gameover(reason : String):
	game_text.text = reason
	home_screen.hide()
	gameplay_screen.hide()
	level_complete_screen.hide()
	game_over_screen.show()
	last_level_screen.hide()
	recipe_book_screen.hide()
	$BackgroundMusic.stop()


func show_last_level():
	#add code here
	home_screen.hide()
	gameplay_screen.hide()
	level_complete_screen.hide()
	game_over_screen.hide()
	last_level_screen.show()
	recipe_book_screen.hide()
	$BackgroundMusic.stop()

func show_recipe_book(recipe_list : Array[Item]):
	recipe_book_screen.show()
	

#func show_text(text):
	#$TitleText.text = text
	#$TitleText.show()
	
	
# Update score
func update_score(score):
	score_label.text = "Score: " + str(score)

# Update level text display
func update_level(level):
	level_label.text = "Level " + str(level)

func update_progressbar(time_left : float):
	progress_bar.value = time_left
	
	if time_left <= 10 :
		progress_bar.modulate = Color.RED
	elif time_left > 10 && time_left < 25:
		progress_bar.modulate = Color.YELLOW
	else:
		progress_bar.modulate = Color.GREEN

func quick_show_text(text : String):
	quick_label.text = text
	quick_label.show()
	text_timer.start()

# Displayed unlocked recipe between levels
func display_unlocked_recipe(level : int, new_recipe : Array[Item]):
	var ingredient = 0
	# Three slots
	for slot in unlocked_ingredients_container.get_children():
		print("ingredient: ", new_recipe[ingredient])
		slot.item = new_recipe[ingredient]
		ingredient = ingredient + 1
	food_unlocked.item = new_recipe[3]
	print("food_unlocked.item: ", food_unlocked.item)


func update_recipe_book(recipe_book : Array[Item]):
	#each recipe in the aray has 3 ingredients then a product, so taking up four indexes
	var recipe_count = recipe_book.size() / 4
	for recipe_slot in recipe_container.get_children():
		recipe_slot.queue_free()
	for i in range(0, recipe_count):
		var slot = recipe_book_slot.instantiate()
		recipe_container.add_child(slot)
		for j in range(0, 4):
			var unlocked_slot_index = "HBoxContainer/UnlockedSlot" + str(j)
			var unlocked_slot = slot.get_node(unlocked_slot_index)
			#i + j depending on which recipe we making
			unlocked_slot.item = recipe_book[(i*4)+j]
	
# Initial screen is the home screen
func _ready():
	show_home()

# Buttons and signals
# Run this function when Home Screen Start pressed
func _on_start_button_pressed() -> void:
	show_gameplay()
	start_game.emit()

# Run this function when Level Complete Home Button pressed
func _on_home_button1_pressed() -> void:
	reset_level.emit()
	show_home()
	
# Run this function when Game Over Home Button pressed
func _on_home_button2_pressed() -> void:
	reset_level.emit()
	show_home()

# Run this function when Last Level Home Button pressed
func _on_home_button3_pressed() -> void:
	reset_level.emit()
	show_home()

# Run this function when Level Complete Next Level Button pressed
func _on_next_level_button_pressed() -> void:
	show_gameplay()
	next_level.emit()

# Run this function when Game Over Try Again pressed
func _on_try_again_button_pressed() -> void:
	show_gameplay()
	try_again.emit()

# Hide quick label text when title text timer runs out
func _on_text_timer_timeout() -> void:
	quick_label.hide()


# Run this function when Recipe Book pressed from Gameplay
func _on_recipe_book_button1_pressed() -> void:
	recipe_book_screen.show() 

# Run this function when Recipe Book pressed from Level Complete
func _on_recipe_book_button2_pressed() -> void:
	recipe_book_screen.show() 

# Run this function when Recipe Book pressed from Game Over
func _on_recipe_book_button3_pressed() -> void:
	recipe_book_screen.show() 


func _on_close_recipe_button_pressed() -> void:
	recipe_book_screen.hide() 


func _on_how_to_play_button_pressed() -> void:
	home_screen.hide()
	how_to_play_screen_two.hide()
	how_to_play_screen.show()

# Run this function when How to play Home Button pressed
func _on_home_button4_pressed() -> void:
	how_to_play_screen.hide()
	home_screen.show()


func _on_page_two_button_pressed() -> void:
	how_to_play_screen.hide()
	home_screen.hide()
	how_to_play_screen_two.show()


func _on_page_one_button_pressed() -> void:
	how_to_play_screen.show()
	home_screen.hide()
	how_to_play_screen_two.hide()
