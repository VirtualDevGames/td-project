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

func _process(_delta):
	if Input.is_action_just_pressed("Spacebar"):
		SpawnItem()

func _ready():
	floppy_disk_spawn_points = $Control/Slots.get_children() 

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

func SpawnItem():
	if amount_of_items < amount_of_items_limit :
		var floppy_instance = item_attackSpeedUp.instantiate()
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


