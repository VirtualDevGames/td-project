extends Node2D

class_name GameManager

@onready var hud : Control
@onready var menu : Control
@onready var camera : Camera2D = $Camera2D
@export var floppy_disk_spawn_points : Array[Node]

var currentLevel : Node2D

var amount_of_items : int = 0
var amount_of_items_limit = 8
var inventory_draggable_item = preload("res://Objects/Inventory Items/InventoryDraggableItem.tscn")
var item_spreadshot = preload("res://Objects/Inventory Items/SpreadShot_InventoryDraggableItem.tscn")
var item_rangeup = preload("res://Objects/Inventory Items/RangeUp_InventoryDraggableItem.tscn")
var item_attackSpeedUp = preload("res://Objects/Inventory Items/AttackSpeed_InventoryDraggableItem.tscn")
var item_explosive = preload("res://Objects/Inventory Items/InventoryDraggableItem.tscn")

var fire_trait = preload("res://Objects/Traits/Fire.tres")
var grass_trait = preload("res://Objects/Traits/Grass.tres")
var ice_trait = preload("res://Objects/Traits/Ice.tres")
var rock_trait = preload("res://Objects/Traits/Rock.tres")
var mystic_trait = preload("res://Objects/Traits/Mystic.tres")
var piercing_trait = preload("res://Objects/Traits/Piercing.tres")
var reroll_trait = preload("res://Objects/Traits/Reroll.tres")
var swift_trait = preload("res://Objects/Traits/Swift.tres")

var traits : Array[TraitResource]  = [
	# Classes
	fire_trait,
	grass_trait,
	ice_trait,
	rock_trait,
	# Oddity
	mystic_trait,
	piercing_trait,
	reroll_trait,
	swift_trait
]

var old_traits_dictionary = [
	# Classes
	{"name": "Rock",  "amount" : 0},
	{"name": "Fire",  "amount" : 1},
	{"name": "Ice",   "amount" : 0},
	{"name": "Grass", "amount" : 2},
	# Oddities
	{"name": "Piercing", "amount" : 0},
	{"name": "Swift",    "amount" : 0},
	{"name": "Reroll",   "amount" : 0},
	{"name": "Mystic",   "amount" : 0},
]

# Classes
var rock_trait_tracker : int
var fire_trait_tracker : int
var ice_trait_tracker : int
var grass_trait_tracker : int
# Oddity
var piercing_trait_tracker : int
var swift_trait_tracker : int
var reroll_trait_tracker : int
var mystic_trait_tracker : int

func _process(_delta):
	if Input.is_action_just_pressed("Spacebar"):
		UiSignals.emit_signal("increase_score")
		#SpawnItem(item_spreadshot)
		#SpawnItem(item_rangeup)
		#SpawnItem(item_attackSpeedUp)
		#SpawnItem(item_explosive)

func _ready():
	SortTraits()
	UiSignals.update_traits_column.emit()

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
	#SortTraits()


#var held_item : Inventory
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
		add_child(floppy_instance)
		#SetItemUpgradeParameters(floppy_instance, TowerData.Properties.damage, 1)
		floppy_instance.global_position = floppy_disk_spawn_points[amount_of_items].global_position
		(floppy_instance as InventoryDraggableItem).GetOriginalPosition(floppy_disk_spawn_points[amount_of_items].global_position)
		amount_of_items = amount_of_items + 1

func SetItemUpgradeParameters(item_instance    : InventoryDraggableItem, \
							  upgrade_property : TowerData.Properties,   \
							  upgrade_value    : float):
	item_instance.upgrade_property = upgrade_property
	item_instance.upgrade_value = upgrade_value

func GetUISlots():
	floppy_disk_spawn_points = $Control/Slots.get_children() 

func _on_world_boundaries_area_entered(area):
	area.call_deferred("queue_free")


