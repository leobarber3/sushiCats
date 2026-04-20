extends Node

var score

func game_over():
	$HUD.show_game_over()


#the time requirement for order to be met
#gaem over if timeout
func _on_customer_timer_timeout() -> void:
	pass # Replace with function body.

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_text("Start!")
	$Game.start_game()


	
	
	
	
	
