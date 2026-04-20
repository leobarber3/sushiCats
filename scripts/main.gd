extends Node

var score

func game_over():
	$HUD.show_game_over()
	
#HUD can have func to hanldle text on screen
#display a game over text then back to orig start screen
#on start have to talk with cat to get order
#some user interaction to create recipe
#some bool maybe to say orders done?
#need to have an inventory of some kind?


#the time requirement for order to be met
#gaem over if timeout
func _on_customer_timer_timeout() -> void:
	game_over()
	pass # Replace with function body.

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_text("Start!")
	$Game.start_game()

	
	
	
	
	
