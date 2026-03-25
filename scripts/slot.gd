extends Panel

#to be used for drag and drop functionalities 
#also inventory
#just messing around w it
@export var item : Item =  null:
	set(value):
		item = value
		#if item is null set texture to null & amount to ""
		if value == null: 
			$Img.texture = null
			$Amount.text = ""
			return
			
		$Img.texture = value.image #if not null set item
		#getting a weird error here isk the issue
	
#could implement similar to crafting/cooking tutorial??
#leaving it here for now will play more with later
#need to implement drag drop mechanics

#item texture rect to show image and label to hold amount
@export var amount : int = 0:
	set(value):
		amount = value
		$Amount.text = str(value) #sets value as text, if <0 then null
		if amount <= 0:
			item = null
		
func _can_drop_data(at_position, data):
	return is_instance_of(data.item, Item)
