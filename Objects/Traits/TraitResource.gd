extends Resource

class_name TraitResource

@export var name_ = ""
@export var trait_type : TraitType
@export var amount = 0
@export var tier_cuttoffs : Array[int]
@export var icon : CompressedTexture2D
var tier = 1

enum TraitType {
	Class,
	Oddity,
}
