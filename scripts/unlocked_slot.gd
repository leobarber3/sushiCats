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
