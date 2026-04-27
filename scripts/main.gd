extends Node

#is this variable causing problems with the game score?? 
#var score
#
## This function is never actually used yet
#func game_over():
	#$HUD.show_game_over()
#
#
#
#
#func new_game():
	#score = 0
	#$HUD.update_score(score)
	#$HUD.show_text("Start!")
	#$Game.start_game()
#
#
	#
	#
	#
# Connecting HUDS start game signal to Games start_game logic
func _ready():
	$HUD.start_game.connect($Game.start_game)
	$HUD.next_level.connect($Game.start_game)
	$HUD.try_again.connect($Game.try_again)
	$HUD.reset_level.connect($Game.reset_level)
