extends CanvasLayer

#signal start_game() once start game is ready 

func show_text(text):
	$TitleText.text = text
	$TitleText.show()
	
#func show_game_over():

func _on_button_pressed() -> void:
	$StartButton.hide()
	$TitleText.hide()
