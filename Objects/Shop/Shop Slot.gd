extends Control

class_name ShopSlot

@onready var slot_sprite = $Button/Background
@onready var animated_sprite = $"Tower Animated Sprite"
@onready var trait_1_label = $"Trait Labels/Trait 1"
@onready var trait_2_label = $"Trait Labels/Trait 2"
@onready var trait_3_label = $"Trait Labels/Trait 3"
@onready var trait_1_icon = $"Trait Icons/Trait Icon 1"
@onready var trait_2_icon = $"Trait Icons/Trait Icon 2"
@onready var trait_3_icon = $"Trait Icons/Trait Icon 3"
@onready var cost_label = $"Cost Panel/Cost Label"

@onready var common_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_common.png")
@onready var uncommon_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_uncommon.png")
@onready var rare_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_rare.png")
@onready var epic_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_epic.png")
@onready var legendary_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_legendary.png")
@onready var unique_sprite = preload("res://Resources/UI/Shop Slot Sprites/shop_slot_unique.png")

var trait_labels = [trait_1_label, trait_2_label, trait_3_label]
@export var tower : TowerData

func _ready():
	UpdateButton()

func UpdateButton():
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
	cost_label.text = str(tower.cost)

func _on_button_pressed():
	pass#print("a")

func _on_button_button_down():
	print("Pressed button: ", get_instance_id())
