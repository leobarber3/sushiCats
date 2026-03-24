extends RigidBody2D
var order; 


#need to set up actual cooking system
#logistically customer needs to spawn at a set position
#and show text / have var of desired order
#currently texture rect just has the image no actual var established with it
#connecting a timer 
func _ready() -> void:
	$AnimatedSprite2D.animation = "idle"
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
