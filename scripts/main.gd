extends Node

# Connecting HUD signals to Game functions
func _ready():
	$HUD.start_game.connect($Game.start_game)
	$HUD.next_level.connect($Game.start_game)
	$HUD.try_again.connect($Game.try_again)
	$HUD.reset_level.connect($Game.reset_level)
