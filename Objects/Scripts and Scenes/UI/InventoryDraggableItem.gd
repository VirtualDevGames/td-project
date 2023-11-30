extends Node2D

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var hover_timer = $"Hover Timer"

signal picked_up_changed(picked)
signal mouse_released

var can_hover:bool = true
var raised:bool = false
@onready var original_location:Vector2 = global_position
@onready var raise_position = Vector2(global_position.x, global_position.y - 13)

var varAlph = 0.0

var picked_up:bool = false :
	set(b):
		if not b:
			global_position = original_location
		picked_up = b
		picked_up_changed.emit(b)

func _process(delta):
	if picked_up:
		global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("M1") : 
		mouse_released.emit()
	
	if raised && !picked_up:
		global_position.y = lerp(original_location.y, raise_position.y, varAlph)
		if varAlph < .5:
			varAlph = varAlph + .01

func _on_mouse_region_pressed():
	varAlph = 0
	if not picked_up:
		can_hover = false
		timer.start()
		#original_location = global_position

func _on_timer_timeout():
	if not picked_up:
		picked_up = true
		can_hover = false
		z_index = 2
		await mouse_released
		hover_timer.start()
		picked_up = false
		z_index = 0

func _on_mouse_released():
	if not timer.is_stopped():
		timer.stop()
		picked_up = true
		can_hover = false
		z_index = 2
		await mouse_released
		hover_timer.start()
		picked_up = false
		z_index = 0

func _on_mouse_region_mouse_entered():
	varAlph = 0
	if can_hover:
		raised = true

func _on_mouse_region_mouse_exited():
	varAlph = 0
	if raised && !picked_up :
		global_position = original_location
	raised = false

func _on_hover_timer_timeout():
	can_hover = true
