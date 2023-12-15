extends Control

class_name ShopSlot

@export var slot_sprite : Sprite2D
@export var animated_sprite : AnimatedSprite2D
@export var trait_1_label : Label
@export var trait_2_label : Label
@export var trait_3_label : Label
@export var trait_1_icon : Sprite2D
@export var trait_2_icon : Sprite2D
@export var trait_3_icon : Sprite2D

@onready var common_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_common.png")
@onready var uncommon_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_uncommon.png")
@onready var rare_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_rare.png")
@onready var epic_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_epic.png")
@onready var legendary_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_legendary.png")
@onready var unique_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_unique.png")



var trait_labels = [trait_1_label, trait_2_label, trait_3_label]

@export var tower : TowerData

func _ready():
	#slot_sprite.texture = legendary_sprite
	animated_sprite.sprite_frames = tower.animation
	animated_sprite.play()
	
	if tower.class_trait != TowerData.Class.None :
		trait_1_label.text = "- " + tower.Class.keys()[tower.class_trait]
		trait_1_icon.visible = true
	if tower.oddity_trait != TowerData.Oddity.None :
		trait_2_label.text = "- " + tower.Oddity.keys()[tower.oddity_trait]
		trait_2_icon.visible = true
	if tower.oddity_2_trait != TowerData.Oddity.None :
		trait_3_label.text = "- " + tower.Oddity.keys()[tower.oddity_2_trait]
		trait_3_icon.visible = true
