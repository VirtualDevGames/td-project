extends Control

class_name TraitLabel

var bronze_frame = preload("res://Resources/Sprites/Traits/BronzeFrame.png")
var silver_frame = preload("res://Resources/Sprites/Traits/SilverFrame.png")
var gold_frame = preload("res://Resources/Sprites/Traits/GoldFrame.png")
var frames = [bronze_frame, silver_frame, gold_frame]

var rock_icon = preload("res://Resources/Sprites/Traits/Rock.png")

@export var trait_icon : TextureRect
@export var frame_icon : TextureRect
@export var text : Label

var _trait : TraitResource

func SetText(_text : String) :
	text.text = _text

func UpdateLabel():
	trait_icon.texture = _trait.icon
	frame_icon.texture = frames[_trait.tier-1]
	text.text = "(" + str(_trait.amount) + ") " + _trait.name_

func SetVisible(b : bool):
	visible = b

func ToggleVisible():
	visible = !visible

func WipeTrait():
	_trait = null
