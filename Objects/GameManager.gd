extends Node2D

class_name GameManager

@onready var hud : Control
@onready var menu : Control
@onready var camera : Camera2D = $Camera2D
var currentLevel : Node2D

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
