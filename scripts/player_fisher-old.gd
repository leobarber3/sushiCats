#can also delete this
extends CharacterBody2D

#
#const SPEED = 130.0
#const JUMP_VELOCITY = -300.0
#@onready var animated_sprite = $AnimatedSprite2D
#@onready var tile_marker =  $AnimatedSprite2D/tileMarker
#
#var startFishing = false
#var waitFishing = false
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta 
#
	##begin code for fishing mechanics 
	#if startFishing: _fishing_state()
	#else: _move_state()
	#move_and_slide()
	
#func _fishing_state():
	#velocity = Vector2.ZERO
	##ui_accept == like space or enter
	#if Input.is_action_just_pressed("stop"): _stop_fishing()
	#if waitFishing: print("waiting for fish")
#
#func _move_state():
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("move_left", "move_right")
	#
	##flip sprite depending on direction moving
	##right movement
	#if direction > 0:
		#animated_sprite.flip_h = false
	#elif direction < 0:
		#animated_sprite.flip_h = true
	##playAnimatinos
	#if direction == 0:
		#animated_sprite.play("idle")	
	##move
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	##ui_accept = space | enter
	#if Input.is_action_just_pressed("ui_accept"):
		#_start_fishing()
		#return
		
#func _start_fishing():
	##if tilemarker is not on water do nothing
	#if not _get_tile_data() == "water": return 
	##otherwise set variable to true and animate correctly
	#startFishing = true
	#animated_sprite.play("cast")
	
#func _stop_fishing():
	#waitFishing = false
	#animated_sprite.play("reelin")

#func _get_tile_data():
	#var tileMap = get_parent().find_child("TileMap")
	#var searchPosition = tileMap.local_to_map(tile_marker.global_position)
	#var data = tileMap.get_cell_tile_data(0, searchPosition)
	#
	#if data: return data.get_custom_data("type")
	
#
#func _on_animated_sprite_2d_animation_finished() -> void:
	##waiting for fish
	#if animated_sprite.animation == "cast":
		#waitFishing = true
	##otherwise done fishing
	#elif animated_sprite.animation == "reelin":
		#startFishing = false
