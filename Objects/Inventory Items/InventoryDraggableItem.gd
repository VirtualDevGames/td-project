extends Node2D

class_name InventoryDraggableItem

@export var tower_data : TowerData
@export var upgrade_property : TowerData.Properties
@export var upgrade_value : float = 0
@export var on_hit_type : OnHitTypes.Types

@export var _sprite : CompressedTexture2D

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var hover_timer = $"Hover Timer"
@onready var area : Area2D = $Sprite2D/Area2D

signal picked_up_changed(picked)
signal mouse_released

var can_hover:bool = true
var raised:bool = false
@onready var original_location = Vector2(0,0)#global_position
@onready var raise_position = Vector2(global_position.x, global_position.y - 13)
@onready var original_scale = scale

var upwards_peek_varAlph = 0.0
var scale_small_pickup_varAlph = 0.0
var move_to_mouse_varAlph = 0.0

func _ready():
	if _sprite:
		sprite.texture = _sprite
		
var picked_up:bool = false :
	set(b):
		if not b:
			position = original_location #global_position = original_location
		picked_up = b
		picked_up_changed.emit(b)

func _process(_delta):
	if picked_up:
		global_position = lerp(global_position, get_global_mouse_position(), move_to_mouse_varAlph)
		move_to_mouse_varAlph = AlphaVarScaling(move_to_mouse_varAlph, 0.5, 0.1)
	
	if Input.is_action_just_released("Left Click") : 
		if picked_up && area.get_overlapping_areas().size() > 0 :
			var closest_tower = CheckForAreasInsideAreas()
			if closest_tower :
				for _area in area.get_overlapping_areas():
					if _area.get_parent() is TowerBase :
						if (_area.get_parent() as TowerBase).towerData != tower_data :
							if (_area.global_position - global_position) \
							< (closest_tower.global_position - global_position) :
								closest_tower = _area
				(closest_tower.get_parent() as TowerBase).\
				UpgradeProperty(TowerData.Properties.keys()[upgrade_property], upgrade_value)
		mouse_released.emit()
		scale = original_scale
		scale_small_pickup_varAlph = 0
	
	if picked_up :
		scale = lerp(scale, Vector2(.5,.5), scale_small_pickup_varAlph)
		scale_small_pickup_varAlph = AlphaVarScaling(scale_small_pickup_varAlph, 0.5, 0.01)
	
	if raised && !picked_up:
		global_position.y = lerp(original_location.y, raise_position.y, upwards_peek_varAlph)
		upwards_peek_varAlph = AlphaVarScaling(upwards_peek_varAlph, 0.5, 0.01)

func CheckForAreasInsideAreas():
	for areas in area.get_overlapping_areas() :
		if areas.get_parent() is TowerBase :
			return areas
	return null

func AlphaVarScaling(varAlph : float, varAlph_limit : float, speed : float) :
	if varAlph < varAlph_limit:
			return (varAlph + speed)
	return varAlph

func GetOriginalPosition(pos : Vector2) :
	original_location = pos
	raise_position = Vector2(pos.x, pos.y - 13)

func _on_mouse_region_pressed():
	#upwards_peek_varAlph = 0
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
		can_hover = true#hover_timer.start()
		picked_up = false
		z_index = 0

func _on_mouse_released():
	if not timer.is_stopped():
		timer.stop()
		picked_up = true
		can_hover = false
		z_index = 2
		await mouse_released
		can_hover = true#hover_timer.start()
		picked_up = false
		z_index = 0

func _on_mouse_region_mouse_entered():
	upwards_peek_varAlph = 0
	if can_hover:
		raised = true

func _on_mouse_region_mouse_exited():
	upwards_peek_varAlph = 0
	if raised && !picked_up :
		position = Vector2(0,0)# original_location #global_position = original_location
	raised = false

func _on_hover_timer_timeout():
	can_hover = true
