extends Panel

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
	# do not let anyone drop data in product_slot
	return false

func _get_drag_data(_at_position):
	# When dragging, check slot for item
	if item:
		# create new texture rect to display a preview of the ingredient
		var preview_image = TextureRect.new()
		preview_image.texture = item.image
		# size and position of image (in relation to mouse)
		preview_image.size = Vector2(48, 48)
		preview_image.position = -Vector2(24, 24)
		
		# Add texture to a control node and display control at mouse
		var preview = Control.new()
		# ensure preview displays over other UI
		preview.z_index = 5
		preview.add_child(preview_image)
		set_drag_preview(preview)
		
		# store item before clearing it
		var dragged_item = item
		item = null
		return {"item" : dragged_item}
	
	return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
