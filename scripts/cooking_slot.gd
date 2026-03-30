extends Panel

# Same variable as ingredient_slot
@export var item : Item = null:
	# runs whenever the variable is changed
	set(value):
		item = value
		
		if value == null:
			$Image.texture = null
			#$Name.text= ""
			return
		
		$Image.texture = value.image

# Note: 
# _can_drop_data, _drop_data, and _get_drag_data are built-in functions responsible for drag & drop of any control nodes

func _can_drop_data(_at_position, data):
	# check for variable item in data
	if "item" in data:
		# return true if item is of type Item
		return is_instance_of(data.item, Item)
	return false

func _drop_data(_at_position, data):
	# set item from returned dictionary
	# overwrite value there if new ingredient is dragged in
	item = data.item
	
func _get_drag_data(_at_position):
	# Possibly for dragging ingredients back out of the ingredient_slot
	if item:
		# create new texture rect to display a preview of the ingredient
		var preview_image = TextureRect.new()
		preview_image.texture = item.image
		
		
		# Prevent image having big minimum size
		preview_image.custom_minimum_size = Vector2(32,32)
		preview_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		preview_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		# size and position of image (in relation to mouse)
		preview_image.size = Vector2(48, 48)
		preview_image.position = -Vector2(24, 24)
		
		
		
		# Add texture to a control node and display control at mouse
		var preview = Control.new()
		preview.size = Vector2(48,48)
		# ensure preview displays over other UI
		preview.z_index = 5
		preview.add_child(preview_image)
		set_drag_preview(preview)
		
		return {"item" : item}
	return null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
