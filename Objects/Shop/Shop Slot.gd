extends Control

class_name ShopSlot

@export var animated_sprite : AnimatedSprite2D
@export var trait_1_label : Label
@export var trait_2_label : Label
@export var trait_3_label : Label
var trait_labels = [trait_1_label, trait_2_label, trait_3_label]

@export var tower : TowerData

func _ready():
	animated_sprite.sprite_frames = tower.animation
	animated_sprite.play()
	
	if tower.class_trait != TowerData.Class.None :
		trait_1_label.text = "- " + tower.Class.keys()[tower.class_trait]
	if tower.oddity_trait != TowerData.Oddity.None :
		trait_2_label.text = "- " + tower.Oddity.keys()[tower.oddity_trait]
	if tower.oddity_2_trait != TowerData.Oddity.None :
		trait_3_label.text = "- " + tower.Oddity.keys()[tower.oddity_2_trait]
