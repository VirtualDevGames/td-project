extends Node2D

class_name GameManager

@onready var hud : Control
@onready var menu : Control
@onready var camera : Camera2D = $Camera2D
@onready var map : WorldMap = $Map1
@export var floppy_disk_spawn_points : Array[Node]
@export var inventory_ui : Control

var current_tilemap : WorldMap
# UI toggle
var moving_ui : bool = false
var ui_on_left : bool = true
var ui_move_direction = -1
var ui_target_location_right = -21
var ui_target_location_left = -122

var currentLevel : Node2D

var amount_of_items : int = 0
var amount_of_items_limit = 8
var inventory_draggable_item = preload("res://Objects/Inventory Items/InventoryDraggableItem.tscn")
var item_spreadshot          = preload("res://Objects/Inventory Items/SpreadShot_InventoryDraggableItem.tscn")
var item_rangeup             = preload("res://Objects/Inventory Items/RangeUp_InventoryDraggableItem.tscn")
var item_attackSpeedUp       = preload("res://Objects/Inventory Items/AttackSpeed_InventoryDraggableItem.tscn")
var item_explosive           = preload("res://Objects/Inventory Items/InventoryDraggableItem.tscn")

var fire_trait     = preload("res://Objects/Traits/Fire.tres")
var grass_trait    = preload("res://Objects/Traits/Grass.tres")
var ice_trait      = preload("res://Objects/Traits/Ice.tres")
var rock_trait     = preload("res://Objects/Traits/Rock.tres")
var mystic_trait   = preload("res://Objects/Traits/Mystic.tres")
var piercing_trait = preload("res://Objects/Traits/Piercing.tres")
var reroll_trait   = preload("res://Objects/Traits/Reroll.tres")
var swift_trait    = preload("res://Objects/Traits/Swift.tres")
var thunder_trait  = preload("res://Objects/Traits/Thunder.tres")
var wind_trait     = preload("res://Objects/Traits/Wind.tres")

var traits : Array[TraitResource]  = [
	# Classes
	fire_trait,
	grass_trait,
	ice_trait,
	rock_trait,
	thunder_trait,
	wind_trait,
	# Oddity
	mystic_trait,
	piercing_trait,
	reroll_trait,
	swift_trait
]

var dragtower = preload("res://Objects/Inventory Items/DraggableTowerBase.tscn")

func _ready():
	GetCurrentTilemap()
	GetUISlots()
	SortTraits()
	UiSignals.update_traits_column.emit()
	UiSignals.add_tower.connect(UpdateTrait)

# Inventory UI  x original -122 target -20 
func _process(_delta):
	if moving_ui:
		MoveInventory()

func _input(event):
	if Input.is_action_just_pressed("Spacebar"):
		SpawnItem(dragtower)
	if Input.is_action_just_pressed("E"):
		if not moving_ui:
			moving_ui = true
			ui_move_direction = -ui_move_direction

func SortTraits():
	traits.sort_custom(SortByTraitAmount)

func SortByTraitAmount(a : TraitResource, b : TraitResource):
	if a.amount > b.amount:
		return true
	return false

func PrintTraits():
	for t in traits :
		print(t.name_, "  ", t.amount)
	print("")

func LoadLevel(levelName : String) :
	UnloadLevel()
	var levelPath = "res://Objects/Maps/%s.tscn" % levelName
	var levelResource = load(levelPath)
	if levelResource :
		currentLevel = levelResource.instantiate()
		add_child(currentLevel)

func UnloadLevel() :
	if is_instance_valid(currentLevel) :
		currentLevel.queue_free()
	currentLevel = null

func SpawnItem(item_to_spawn : PackedScene):
	if amount_of_items < amount_of_items_limit :
		var floppy_instance = item_to_spawn.instantiate()
		floppy_disk_spawn_points[amount_of_items].add_child(floppy_instance)
		#SetItemUpgradeParameters(floppy_instance, TowerData.Properties.damage, 1)
		floppy_instance.global_position = floppy_disk_spawn_points[amount_of_items].global_position
		#(floppy_instance as InventoryDraggableItem).GetOriginalPosition(floppy_disk_spawn_points[amount_of_items].global_position)
		floppy_instance.GetOriginalPosition(floppy_disk_spawn_points[amount_of_items].global_position)
		amount_of_items = amount_of_items + 1

func SetItemUpgradeParameters(item_instance    : InventoryDraggableItem, \
							  upgrade_property : TowerData.Properties,   \
							  upgrade_value    : float):
	item_instance.upgrade_property = upgrade_property
	item_instance.upgrade_value = upgrade_value

func GetUISlots():
	floppy_disk_spawn_points = $Inventory/Slots.get_children() 

func MoveInventory():
	inventory_ui.position.x += ui_move_direction
	if ui_move_direction > 0 :
		if inventory_ui.position.x >= ui_target_location_right :
			moving_ui = false
	else :
		if inventory_ui.position.x <= ui_target_location_left :
			moving_ui = false

func UpdateTrait(tower : TowerBase, amount : int) :
	var success = false
	for t in traits :
		if t.name_ == TowerData.Class.keys()[tower.towerData.class_trait] :
			t.amount += amount
			success = true
		elif t.name_ == TowerData.Oddity.keys()[tower.towerData.oddity_trait] : 
			t.amount += amount
			success = true
		elif t.name_ == TowerData.Oddity.keys()[tower.towerData.oddity_2_trait] : 
			t.amount += amount
			success = true
	if success :
		SortTraits()
		UiSignals.update_traits_column.emit()

func _on_world_boundaries_area_entered(area):
	area.call_deferred("queue_free")

func GetCurrentTilemap():
	for child in get_children() :
		if child is WorldMap :
			current_tilemap = child
			break


