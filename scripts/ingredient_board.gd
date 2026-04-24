extends Panel

@export var ingredient_slot_scene : PackedScene
@onready var slot_container = $ScrollContainer/VBoxContainer


func set_ingredients(available_ingredients : Array[Item]):
	for slot in slot_container.get_children():
		slot.queue_free()
		
	for ingredient in available_ingredients:
		# Instantiate a new slot
		var slot = ingredient_slot_scene.instantiate()
		slot_container.add_child(slot)
		slot.item = ingredient
