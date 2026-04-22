extends CanvasLayer

signal start_game #once start game is ready 
#@export var round : int = 0 not even using this variable??


func show_text(text):
	$TitleText.text = text
	$TitleText.show()
	$textTimer.start()
	
func show_game_over():
	$TextureRect.show()
	show_text("Level Over")
	$StartButton.show()
	update_score(0)
	#$ScoreLabel.hide()
	$BackgroundMusic.stop()	
	$ScoreLabel.hide()

 
	#need to add logc to stop cats from spawning?s
	#could use group logic like in 2d tutorial?
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_level(level):
	$LevelLabel.text = "Level " + str(level)
	
func _on_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
	$TextureRect.hide()
	$BackgroundMusic.play()	
	$LevelLabel.show()
	$ScoreLabel.show()
	
	
func _on_text_timer_timeout() -> void:
	$TitleText.hide()
