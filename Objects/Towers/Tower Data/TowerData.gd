extends Resource

class_name TowerData

enum Properties {
	name,
	cost,
	damage,
	on_hit_type,
	on_hit_damage,
	explosive,
	amount_of_shots,
	pierces,
	shootingSpeed,
	projectileSpeed,
	_range,
}

# Main trait of tower
enum Class {
	None,
	Rock,
	Fire,
	Ice,
	Wind,
	Thunder,
	Grass,
}
# Secondary trait of tower
enum Oddity {
	None,
	Piercing,
	Swift,
	Reroll,
	Mystic,
}

@export var name : String = ""
@export var animation : SpriteFrames
@export var class_trait : Class
@export var oddity_trait : Oddity
@export var oddity_2_trait : Oddity
@export var cost : int = 1
@export var damage : int = 1
@export var on_hit_type : OnHitTypes.Types
@export var on_hit_damage : int = 0
@export var explosive : int = 0
@export var amount_of_shots : int = 1
@export var pierces : int = 0
@export var shootingSpeed : float = 10
@export var projectileSpeed : float = 100
@warning_ignore("unused_private_class_variable")
@export var _range : float = 50
