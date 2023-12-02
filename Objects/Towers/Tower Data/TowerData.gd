extends Resource

class_name TowerData

enum Properties {
	name,
	cost,
	damage,
	on_hit_type,
	on_hit_damage,
	amount_of_shots,
	pierces,
	shootingSpeed,
	projectileSpeed,
	_range,
}
@export var name : String = ""
@export var cost : int = 0
@export var damage : int = 0
@export var on_hit_type : OnHitTypes.Types
@export var on_hit_damage : int = 0
@export var amount_of_shots : float = 1.0
@export var pierces : int = 0
@export var shootingSpeed : float = 0.0
@export var projectileSpeed : float = 0.0
@warning_ignore("unused_private_class_variable")
@export var _range : float = 0.0
