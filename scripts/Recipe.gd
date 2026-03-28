extends Resource
class_name Recipe

#a recipe will have a name and an image
@export var name : String
@export var image : Texture2D
#a recipe will also have ingredients and a product
#an ingredient will be an item of __ index
@export var ingredients : Dictionary[int, Item]
#the result of a recipe will be an item
@export var product : Item
#the recipe will make 1 of each item
@export var recipe_amount : int = 1
#the recipe will take __ amount of time to cook.. still tbd
@export var recipe_time : float = 0.0
