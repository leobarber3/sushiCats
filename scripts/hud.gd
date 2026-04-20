extends CanvasLayer

signal start_game #once start game is ready 


func show_text(text):
	$TitleText.text = text
	$TitleText.show()
	$textTimer.start()
	
func show_game_over():
	$ColorRect.show()
	show_text("Round Over")
	$TitleText.text = "Welcome to Sushi Fish!"
	$TitleText.show()
	$StartButton.show()
	
	#need to add logc to stop cats from spawning?s
	#could use group logic like in 2d tutorial?
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func _on_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()
	$ColorRect.hide()
	
func _on_text_timer_timeout() -> void:
	$TitleText.hide()
