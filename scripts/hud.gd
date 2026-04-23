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

# Nodes in GameOver Screen
@onready var game_text = $ScreenManager/GameOverScreen/GameText

func show_home():
	home_screen.show()
	gameplay_screen.hide()
	level_complete_screen.hide()
	game_over_screen.hide()
	$BackgroundMusic.stop()
	
func show_gameplay():
	home_screen.hide()
	gameplay_screen.show()
	level_complete_screen.hide()
	game_over_screen.hide()
	$BackgroundMusic.play()

func show_level_complete(level : int, is_last_level : bool):
	if is_last_level:
		level_title.text = "You finished the last level! Congrats!"
	else:
		level_title.text = "Level " + str(level) + " complete!"
	# Hide the next level button if it's the last level, display if not
	$ScreenManager/LevelCompleteScreen/NextLevelButton.visible = !is_last_level
	
	home_screen.hide()
	gameplay_screen.hide()
	level_complete_screen.show()
	game_over_screen.hide()
	$BackgroundMusic.stop()

func show_gameover(reason : String):
	game_text.text = reason
	home_screen.hide()
	gameplay_screen.hide()
	level_complete_screen.hide()
	game_over_screen.show()
	$BackgroundMusic.stop()
	
	
	

#func show_text(text):
	#$TitleText.text = text
	#$TitleText.show()
	
	
# Update score
func update_score(score):
	score_label.text = str(score)

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


# OLD : Display game over screen.
#func show_game_over():
	#$TextureRect.show()
	##show_text("Level Over")
	#$StartButton.show()
	#update_score(0)
	##$ScoreLabel.hide()
	#$BackgroundMusic.stop()	
	#$ScoreLabel.hide()

# OLD : Start button is pressed, run this function
#func _on_start_pressed() -> void:
	#$StartButton.hide()
	#start_game.emit()
	#$TextureRect.hide()
	#$BackgroundMusic.play()	
	#$LevelLabel.show()
	#$ScoreLabel.show()
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
	
