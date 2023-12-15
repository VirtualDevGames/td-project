extends Node2D

class_name TowerBase

var projectile = preload("res://Objects/Projectiles/ProjectileBase.tscn")

@export var dice : DiceRoller

var isFollowingTarget = false
var targetObject : EnemyBase
var enemiesArray : Array[EnemyBase]

var smoothed_look_at_pos : Vector2
var animcounter : float

var canShoot : bool = true
var dice_damage = 0

# Tower Data Variables
@export var towerData : TowerData
var towerType : int = 0
var tname : String = ""
var cost : int = 0
@onready var shootingTimer = $Timer
@onready var _range : CollisionShape2D = $Range/Range
@onready var draggable_item_collision : CollisionShape2D = $"Draggable Item Collision/CollisionShape2D"

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var crosshair = $crosshair

func _ready():
	SetTowerData(towerData)

func _process(_delta):
	pass

func _physics_process(_delta):
	if enemiesArray.size() > 0 :
		# Check for all enemies in range for furthest enemy
		targetObject = enemiesArray[0]
		for enemy in enemiesArray :
			var checking = enemy
			if (checking.lifeTime > targetObject.lifeTime) :
				targetObject = checking
		# If has target, shoot it
		crosshair.global_position = targetObject.get_parent().global_position

func TurnToLookAt(pos : Vector2) :
	smoothed_look_at_pos = lerp(smoothed_look_at_pos, pos, 1)
	look_at(smoothed_look_at_pos)

func Shoot() :
	if canShoot :
		canShoot = false
		
		# Roll damage, wait for animation to finish
		dice_damage = dice.RollDice()
		await dice.finished_rolling
		# Start shooting cd
		shootingTimer.start()
		
		if enemiesArray.size() > 0 :
			var space_between_shots = 0.0
			var current_spread = 0
			if towerData.amount_of_shots > 1 :
				space_between_shots = (60.0 / (towerData.amount_of_shots - 1.0))
				current_spread = -30#(space_between_shots * floor(towerData.amount_of_shots/2))
			for n in towerData.amount_of_shots :
				var target_location = targetObject.global_position
				anim.play()
				var projectileInstance : ProjectileBase = projectile.instantiate()
				get_parent().add_child(projectileInstance)
				projectileInstance.global_position = $"AnimatedSprite2D/Shoot Location".global_position
				projectileInstance.speed = towerData.projectileSpeed
				projectileInstance.targetLocation = target_location
				projectileInstance.vel = \
					Vector2(target_location - projectileInstance.global_position).rotated(deg_to_rad(current_spread))
				projectileInstance.onHitProperty = towerData.on_hit_type
				projectileInstance.damage = dice_damage#towerData.damage
				projectileInstance.on_hit_damage = towerData.on_hit_damage
				projectileInstance.hits_left = towerData.pierces
				current_spread = current_spread + space_between_shots
			if enemiesArray.size() > 0 :
				pass#Shoot()


# Set Tower Data
func SetTowerData(data : TowerData) :
	towerData = data
	if data.explosive > 0 :
		data.on_hit_type = OnHitTypes.Types.Explosive
	_range.shape = _range.shape.duplicate()
	tname = data.name
	cost = cost + data.cost
	shootingTimer.set_wait_time(data.shootingSpeed)
	_range.shape.radius = data._range

func UpgradeProperty(property_name : String, value : float) :
	towerData.set(property_name, towerData.get(property_name) + value)
	SetTowerData(towerData)

func GetTowerData() -> TowerData:
	return towerData

# Follow Mouse
func _on_area_2d_mouse_entered():
	pass #isFollowingTarget = true

func _on_area_2d_mouse_exited():
	pass #isFollowingTarget = false

#Enemy Enter/Exit Range
func _on_range_area_entered(area):
	enemiesArray.push_front(area.get_parent()) #enemiesArray.push_front(area.get_parent())
	targetObject = area.get_parent()
	isFollowingTarget = true
	if canShoot :
		Shoot()#shootingTimer.start()
	
func _on_range_area_exited(area):
	enemiesArray.erase(area.get_parent())
	isFollowingTarget = false

func _on_animated_sprite_2d_animation_finished():
	anim.stop()

func _on_timer_timeout():
	canShoot = true
	if enemiesArray.size() < 1 :
		shootingTimer.stop()
	else :
		Shoot()

func _on_draggable_item_collision_area_entered(_area):
	pass

