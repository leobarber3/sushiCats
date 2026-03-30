extends Panel

# array of valid recipes
@export var recipes : Array[Recipe]
# product_slot where food will appear when created
@export var product_slot : Panel
# var holding cooking slots
@onready var cooking_slots = $CookingIngredients

# Function to check if ingredient selection matches recipes!
func check_recipe():
	# loop through recipes in array and check for a match
	for recipe in recipes:
		# variable for checking
		var recipe_match = true
		# loop through each ingredient
		for i in recipe.ingredients:
			var required_ingredient = recipe.ingredients[i]
			var cooking_slot = cooking_slots.get_child(i)
			# perform check
			if cooking_slot.item != required_ingredient:
				recipe_match = false
				# mismatch, break to next
				break
		if recipe_match:
			return recipe
	return null
		

# Cook button! Connected pressed() signal
func _on_cook_pressed() -> void:
	var recipe = check_recipe()
	if recipe:
		# Print for testing:
		print("recipe matches! you made: ", recipe)
		product_slot.item = recipe.product
		empty_slots()
	else:
		# Print for testing:
		print("you made a mess: (no matching recipe)")
		# empty the slots regardless for now : need to indicate to player that they made trash later
		empty_slots()
		

# function to empty slots
func empty_slots():
	for cooking_slot in cooking_slots.get_children():
		cooking_slot.item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
