extends Node

signal order_complete(happy : bool)

@onready var cat = $Cat
@onready var order = $Order

@onready var score_text = $ScoreText
@onready var score_text_timer = $ScoreTextTimer

@onready var wait_timer = $WaitTimer
@onready var wait_progress = $WaitProgress
var patience : float = 0.0
# variable for food the cat wants
var wanted_food: Item = null
# possible wait times for customers
var wait_times = [9, 10, 12, 15, 20]

func setup(food : Item):
	wanted_food = food
	# show food image
	$Order.texture = food.image
	# Pick a random wait time
	var random_time = wait_times[randi() % wait_times.size()]
	wait_timer.wait_time = random_time
	# set cat patience to random_time for progress bar
	patience = random_time
	# progress bar starts at full (goes from 0 to 1.0)
	wait_progress.value = 1.0
	# Testing
	print("cat wants: ", food.name, " and is waiting ", random_time, " seconds")
	# start the customer's wait timer
	wait_timer.start()
	# play animation
	cat.play("idle")
	
# Note: 
# _can_drop_data, and _drop_data, are built-in functions responsible for drag & drop of any control nodes
func _can_drop_data(_at_position, data):
	# Can drop food items here for the customer
	if "item" in data:
		return is_instance_of(data.item, Item)
	return false

func _drop_data(_at_position, data):
	if data.item == wanted_food:
		# Happy customer!
		leave(true)
	else:
		# Unhappy customer!
		leave(false)

# Function to run when customer leaves
func leave(happy : bool):
	wait_timer.stop()
	
	# Customer is happy:
	if happy:
		print("happy cat!")
		score_text.text = "+10"
		score_text_timer.start()
		$HappySound.play()
	else:
		print("unhappy cat")
		score_text.text = "-5"
		score_text_timer.start()
		$UnhappySound.play()
	# Fire signal with happiness variable
	order_complete.emit(happy)
	# wait 1.5 seconds, then remove cat
	await get_tree().create_timer(1.5).timeout
	queue_free()

# Connected to Timer timeout()
func _on_wait_timer_timeout() -> void:
	# function is called when timer runs out, meaning customer never got food:
	leave(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if wait_timer.is_stopped():
		return
	# update the progress bar
	wait_progress.value = wait_timer.time_left / patience
	# change color with modulate property of ProgressBar
	if wait_timer.time_left <= 3 :
		wait_progress.modulate = Color.RED
	elif wait_timer.time_left > 3 && wait_timer.time_left < 8:
		wait_progress.modulate = Color.YELLOW
	else:
		wait_progress.modulate = Color.GREEN

func _on_score_text_timer_timeout() -> void:
	score_text.text=""
