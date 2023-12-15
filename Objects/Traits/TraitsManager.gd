extends Node

class_name TraitsManagerGlobal

var Fire     = preload("res://Objects/Traits/Fire.tres")
var Grass    = preload("res://Objects/Traits/Grass.tres")
var Ice      = preload("res://Objects/Traits/Ice.tres")
var Rock     = preload("res://Objects/Traits/Rock.tres")
var Thunder  = preload("res://Objects/Traits/Thunder.tres")
var Wind     = preload("res://Objects/Traits/Wind.tres")

var Mystic   = preload("res://Objects/Traits/Mystic.tres")
var Piercing = preload("res://Objects/Traits/Piercing.tres")
var Reroll   = preload("res://Objects/Traits/Reroll.tres")
var Swift    = preload("res://Objects/Traits/Swift.tres")

var Traits = [
	# Element
	Fire,
	Grass,
	Ice,
	Rock,
	Thunder,
	Wind,
	#Oddity
	Mystic,
	Piercing,
	Reroll,
	Swift,
]

func _ready():
	SortTraits()
	UiSignals.update_traits_column.emit()
	UiSignals.add_tower.connect(UpdateTrait)

func UpdateTrait(tower : TowerBase, amount : int) :
	var success = false
	for t in Traits :
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


func SortTraits():
	Traits.sort_custom(SortByTraitAmount)

func SortByTraitAmount(a : TraitResource, b : TraitResource):
	if a.amount > b.amount:
		return true
	return false

func PrintTraits():
	for t in Traits :
		print(t.name_, "  ", t.amount)
	print("")
