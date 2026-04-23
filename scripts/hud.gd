extends CanvasLayer

signal start_game #once start game is ready 
#@export var round : int = 0 not even using this variable??

# Display text on screen. If timer is true, start textTimer.
func show_text(text, timer):
	$TitleText.text = text
	$TitleText.show()
	if (timer):
		$textTimer.start()

# Display game over screen.
func show_game_over():
	$TextureRect.show()
	show_text("Level Over", false)
	$StartButton.show()
	update_score(0)
	#$ScoreLabel.hide()
	$BackgroundMusic.stop()	
	$ScoreLabel.hide()

# Update score
func update_score(score):
	$ScoreLabel.text = str(score)

# Update level text display
func update_level(level):
	$LevelLabel.text = "Level " + str(level)
	
# Start button is pressed, run this function
func _on_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
	$TextureRect.hide()
	$BackgroundMusic.play()	
	$LevelLabel.show()
	$ScoreLabel.show()
	
# Hide text when title text timer runs out
func _on_text_timer_timeout() -> void:
	$TitleText.hide()
