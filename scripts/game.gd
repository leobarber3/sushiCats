extends Node

@export var cat_scene : PackedScene
@onready var customer_slots : HBoxContainer = get_node("../UI/CustomerPanel/CustomerSlots")
@export var food_list : Array[Item]
#
#@export var game_timer : Timer
#@export var game_progress : ProgressBar
#variable level to keep track of how far to index through the recipe array
@export var level : int = 1
@export var score : int = 0
var spawn_timer : Timer
var game_overBool : bool = false

@onready var game_timer = $GameTimer
@onready var game_progress = $GameProgress

# Function to spawn a cat customer
func spawn_cat():
	# get all slots and switch order before checking to add randomness in spawning
	var customer_slots = customer_slots.get_children()
	customer_slots.shuffle()
	for customer_slot in customer_slots:
		# No child means no cat in the slot
		if customer_slot.get_child_count() == 0:
			# Instantiate a new cat scene
			var cat = cat_scene.instantiate()
			# add cat to empty slot
			customer_slot.add_child(cat)
			
			#var food = food_list[randi() % food_list.size()]
	
			#this will cause index out of bounds error eventually.
			#if level == food_list.size() || level == 0 :
				#spawn_timer.stop()  
				#start_over()
			#if level is = to food list size then you beat the game!
			if level >= food_list.size():
				var food =  food_list[randi() % food_list.size()]
		
			#this line is where the errors coming from
			var food = food_list[randi() % level]
			cat.setup(food)
			# Connect order_complete signal (from cat.gd) to on_order_complete function
			cat.order_complete.connect(on_order_complete)
			
			# print for testing
			print("cat spawned in slot ", customer_slot.name)
			return
	# No empty slots for cats to spawn in
	print("no empty slots to spawn cats in")

func on_order_complete(happy : bool):
	if happy:
		score += 10
		$"../HUD".update_score(score) 
	else:
		score -= 5
		$"../HUD".update_score(score) 
	print ("score: ", score)
	if score < 0:
		game_overBool = true
		spawn_timer.stop()
		start_over()			
	if score > 40:
		game_overBool = true
		if(game_overBool):
			spawn_timer.stop() #stops cats from spawning
			game_over()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start_game():
	$"../HUD".update_level(level)
	# immediately spawn a cat, want to wait till start button is pressed
	spawn_cat()
	
	# Start game timer and progress bar
	game_timer.wait_time = 60
	game_progress.value = 100.0
	game_timer.start()
	
	# create a new timer to spawn more cats sequentially
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 10.0 # spawn a cat every 10 seconds
	# Connect the spawn_timers timeout() signal to cat
	# so a cat will spawn each 15 second timeout
	spawn_timer.timeout.connect(spawn_cat)
	add_child(spawn_timer)
	spawn_timer.start()
	
func game_over():
	$"../HUD".show_game_over()
	score = 0
	level += 1
	$"../HUD".update_level(level)
	game_overBool = false
	game_timer.stop()
	pass
	
func start_over():
	$"../HUD".show_game_over()
	score = 0
	level = level
	$"../HUD".update_level(level)
	game_overBool = false
	game_timer.stop()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#check for game timer over and if score is 
	#what it needs to be
	#print(score)
	#if score > 10 || game_timer.is_stopped():
		#$"../HUD".show_game_over()
		#print(score)
		# Must stop cats from spawning here
		
		#return
		## stop running the game, ran out of time
	
	
	
	# update the progress bar

	print("game time left: ", game_timer.time_left)
	
	game_progress.value = 60 - game_timer.time_left 
	print("progress bar: ", game_progress.value)
	# change color with modulate property of ProgressBar
	if game_timer.time_left <= 10 :
		game_progress.modulate = Color.RED
	elif game_timer.time_left > 10 && game_timer.time_left < 25:
		game_progress.modulate = Color.YELLOW
	else:
		game_progress.modulate = Color.GREEN
	return


# Game timer times out : game over
func _on_game_timer_timeout() -> void:
	
	#if the timer runs out you go back to the very start... for now
	#this still doesnt clear the cats from prev round
	game_overBool = true
	start_over()
	#this will show the end scree when the timer timesout
	#but we still need to figure out how to clear the cats from the slots
	pass # Replace with function body.
