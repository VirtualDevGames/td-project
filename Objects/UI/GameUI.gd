extends CanvasLayer

class_name GameUI

@export var gameManager : GameManager 
@export var labels_array : Array[TraitLabel]

var score = 0:
	set(new_score):
		score = new_score

func _ready():
	UiSignals.update_traits_column.connect(UpdateTraitsColumn)

func UpdateTraitsColumn():
	var last_checked = 0
	for i in TraitsManager.Traits.size() :
		var test = TraitsManager.Traits[i].amount
		if TraitsManager.Traits[i].amount > 0 :
			labels_array[i]._trait = TraitsManager.Traits[i]
			labels_array[i].SetVisible(true)
			labels_array[i].UpdateLabel()
		else : 
			last_checked = i
			break

	for i in range(last_checked, labels_array.size()):
		if !labels_array[i]._trait:
			labels_array[i].SetVisible(false)
