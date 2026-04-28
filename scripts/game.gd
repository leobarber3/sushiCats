extends Node

@export var cat_scene : PackedScene
@onready var customer_slots : HBoxContainer = get_node("../UI/CustomerPanel/CustomerSlots")
@export var food_list : Array[Item]
# Implementing ingredient_list to instantiate ingredients as needed
#@onready var ingredient_board = $"../UI/IngredientBoard/ScrollContainer/VBoxContainer"
@onready var ingredient_board = $"../UI/IngredientBoard"
@onready var cooking_board = $"../UI/CookingBoard"
@export var ingredient_list : Array[Item]
#@export var game_timer : Timer
#@export var game_progress : ProgressBar
#variable level to keep track of how far to index through the recipe array
@export var level : int = 1
@export var score : int = 0
var spawn_timer : Timer
var game_overBool : bool = false

@onready var game_timer = $GameTimer

@onready var hud = $"../HUD"

# Function to spawn a cat customer
func spawn_cat():
	# get all slots and switch order before checking to add randomness in spawning
	var slots = customer_slots.get_children()
	slots.shuffle()
	for customer_slot in slots:
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
			# if level is = to food list size then you beat the game!
			# OLD: 
			#if level >= food_list.size():
				#var food =  food_list[randi() % food_list.size()]

			# Chooses between food_list size and level to avoid out of bounds index
			var food = food_list[randi() % min(level, food_list.size())]
			cat.setup(food)
			# Connect order_complete signal (from cat.gd) to on_order_complete function
			cat.order_complete.connect(on_order_complete)
			
			# print for testing
			print("cat spawned in slot ", customer_slot.name)
			return
	# No empty slots for cats to spawn in
	print("no empty slots to spawn cats in")

func clear_cats():
	for slot in customer_slots.get_children():
		for cat in slot.get_children():
			cat.queue_free()



func on_order_complete(happy : bool):
	if happy:
		score += 10
	else:
		score -= 5
	hud.update_score(score)
	print ("score: ", score)
	if score < 0:
		spawn_timer.stop()
		game_over("Your score went into the negatives!")
		# OLD : start_over()
	elif score > 40:
			spawn_timer.stop()
			level_complete()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func obtain_new_recipe():
	# test function for obtaining most recently added recipe
	var unlocked_recipe : Array[Item] = []
	var unlocked_food = food_list[level]
	# when completing level one, this will grab second recipe
	var new_recipe = cooking_board.recipes[level]
	print("new recipe", new_recipe)
	# Add the 3 new ingredients and new food product to unlocked_recipe list
	unlocked_recipe.append(new_recipe.ingredients[0])
	unlocked_recipe.append(new_recipe.ingredients[1])
	unlocked_recipe.append(new_recipe.ingredients[2])
	unlocked_recipe.append(unlocked_food)
	return unlocked_recipe

# Obtain recipes for the recipe book display
func obtain_recipe_book(is_next_level : bool):
	# Level index
	var recipe_index = level
	# If in the next level screen / "level complete", increment recipe_index to include next level's "unlocked" recipe
	if (is_next_level):
		recipe_index += 1
	var recipe_book : Array[Item] = []
	var recipe_list = cooking_board.recipes
	for i in range(0, recipe_index):
		print("recipe index ", recipe_index)
		print("is next level? ", is_next_level)
		#the three ingredients in said recipe
		recipe_book.append(recipe_list[i].ingredients[0])
		recipe_book.append(recipe_list[i].ingredients[1])
		recipe_book.append(recipe_list[i].ingredients[2])
		recipe_book.append(recipe_list[i].product)
	return recipe_book
	
		
		
	





func update_cooking_recipes():
	var unlocked_recipes : Array[Recipe] = []
	var unlocked_foods = food_list.slice(0, min(level, food_list.size()))
	for food in unlocked_foods:
		for recipe in cooking_board.recipes:
			if recipe.product == food:
				unlocked_recipes.append(recipe)
	cooking_board.unlocked_recipes = unlocked_recipes

func start_game():
	score = 0
	hud.update_score(score)
	hud.update_level(level)
	hud.quick_show_text("Start!")

	# Set up ingredients
	var unlocked_ingredients = get_available_ingredients()
	ingredient_board.set_ingredients(unlocked_ingredients)
	# Update unlocked recipes
	update_cooking_recipes()
	hud.update_recipe_book(obtain_recipe_book(false))
	
	# Clear any existing cats, spawn an initial cat
	clear_cats()
	spawn_cat()

	# Start game timer
	game_timer.wait_time = 60
	game_timer.start()
	
	# Create a new timer to spawn more cats sequentially
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 10.0 # spawn a cat every 10 seconds
	# Connect the spawn_timers timeout() signal to cat
	# so a cat will spawn each 15 second timeout
	spawn_timer.timeout.connect(spawn_cat)
	add_child(spawn_timer)
	spawn_timer.start()
	

func game_over(reason : String):
	game_timer.stop()
	clear_cats()
	hud.show_gameover(reason)
	
func level_complete():
	game_timer.stop()
	clear_cats()
	var is_last = level >= food_list.size()
	if (is_last):
		hud.show_last_level()
	else:
		
		var new_recipe = obtain_new_recipe()
		hud.update_recipe_book(obtain_recipe_book(true))
		# Passing "" for now, optional message disaplyed between levels
		hud.show_level_complete(level, new_recipe, "")
		
	level += 1

func try_again():
	score = 0
	start_game()

func reset_level():
	score = 0
	level = 1

# Obtains available ingredients for creating unlocked food items
func get_available_ingredients() -> Array[Item]:
	var available : Array[Item] = []
	var unlocked_recipes = food_list.slice(0, min(level, food_list.size()))
	# Search list of unlocked recipes to find available ingredients
	for food in unlocked_recipes:
		for recipe in cooking_board.recipes:
			if recipe.product == food:
				# add ingredients if they are not in the list
				for i in recipe.ingredients:
					var ingredient = recipe.ingredients[i]
					if ingredient not in available:
						available.append(ingredient)
	return available
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_timer.is_stopped():
		clear_cats()
		return
	hud.update_progressbar(game_timer.time_left)
	return


# Game timer times out : game over
func _on_game_timer_timeout() -> void:
	spawn_timer.stop()
	game_over("You ran out of time!")
	#this will show the end scree when the timer timesout
	#but we still need to figure out how to clear the cats from the slots
	pass # Replace with function body.
