extends Node2D

class_name TowerBase

var projectile = preload("res://Objects/Scripts and Scenes/Projectiles/ProjectileBase.tscn")

var isFollowingTarget = false
var targetObject : EnemyBase
var enemiesArray : Array[EnemyBase]

var smoothed_look_at_pos : Vector2
var animcounter : float

var canShoot : bool = true

# Tower Data Variables
@export var towerData : Array[TowerData]
var towerType : int = 0
var tname : String = ""
var cost : int = 0
@onready var shootingTimer :  ShootingTimer = $"Shooting Timer"
var projectileSpeed : float = 0
@onready var range : CollisionShape2D = $Range/Range

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var crosshair = $crosshair



enum TowerTypes	{
	Blue = 0,
	Red = 1,
}

func _ready():
	towerType = TowerTypes.Red
	SetTowerData(towerData[towerType])

func _physics_process(_delta):
	if enemiesArray.size() > 0 :
		# Check for all enemies in range for furthest enemy
		targetObject = enemiesArray[0]
		for enemy in enemiesArray :
			var checking = enemy
			if (checking.lifeTime > targetObject.lifeTime) :
				targetObject = checking
		# If has target, follow it
		TurnToLookAt(targetObject.get_parent().global_position)
		crosshair.global_position = targetObject.get_parent().global_position
		if(targetObject != null) :
			Shoot()

func TurnToLookAt(pos : Vector2) :
	smoothed_look_at_pos = lerp(smoothed_look_at_pos, pos, 1)
	look_at(smoothed_look_at_pos)

func Shoot() :
	if canShoot :
		canShoot = false
		if enemiesArray.size() > 0 :
			anim.play()
			var projectileInstance : ProjectileBase = projectile.instantiate()
			projectileInstance.global_position = $"AnimatedSprite2D/Shoot Location".global_position
			projectileInstance.speed = projectileSpeed
			projectileInstance.targetLocation = targetObject.global_position
			projectileInstance.vel = targetObject.global_position - projectileInstance.global_position 
			get_parent().add_child(projectileInstance)

# Set Tower Data
func SetTowerData(data : TowerData) :
	range.shape = range.shape.duplicate()
	tname = data.name
	cost = data.cost
	shootingTimer.set_wait_time(data.shootingSpeed)  
	projectileSpeed = data.projectileSpeed
	range.shape.radius = data.range
	anim.animation = data.name

# Follow Mouse
func _on_area_2d_mouse_entered():
	pass #isFollowingTarget = true

func _on_area_2d_mouse_exited():
	pass #isFollowingTarget = false

#Enemy Enter/Exit Range
func _on_area_2d_area_entered(area):
	enemiesArray.push_front(area.get_parent()) #enemiesArray.push_front(area.get_parent())
	targetObject = area.get_parent()
	isFollowingTarget = true
	if shootingTimer.is_stopped() :
		shootingTimer.start()
	
func _on_area_2d_area_exited(area):
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
