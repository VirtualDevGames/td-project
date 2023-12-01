extends Node2D

class_name GameManager

@onready var hud : Control
@onready var menu : Control
@onready var camera : Camera2D = $Camera2D
@export var inventory_ui : InventoryUI
@export var floppy_disk_spawn_points : Array[Node]

var currentLevel : Node2D

var amount_of_items : int = 0
var amount_of_items_limit = 8
var floppy = preload("res://Objects/Scripts and Scenes/UI/InventoryDraggableItem.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("Spacebar"):
		SpawnItem()

func _ready():
	GetUISlots()

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
		var floppy_instance = floppy.instantiate()
		add_child(floppy_instance)
		floppy_instance.global_position = floppy_disk_spawn_points[amount_of_items].global_position
		(floppy_instance as InventoryDraggableItem).GetOriginalPosition(floppy_disk_spawn_points[amount_of_items].global_position)
		amount_of_items = amount_of_items + 1
	
func GetUISlots():
	floppy_disk_spawn_points = $Control/Slots.get_children() 
	for p in floppy_disk_spawn_points:
		print(p.name + " " + str(p.global_position))
	#InventoryUI.get_child()
	#for node in InventoryUI.get_children() :
		#if node.name.contains("Slot")
		
