extends CharacterBody2D

class_name ProjectileBase

@onready var projectileOnHitVFX : ProjectileOnHitVFX = $ProjectileOnHitVFX
@onready var sprite : Sprite2D = $Sprite2D

@export var explosionHitbox : CollisionShape2D

var damage : int = 1
var speed : float = 1
var targetLocation : Vector2
var vel = Vector2(0,0)
var bulletScale = Vector2(0.8 , 0.8)
var onHitType : OnHitTypes.Types = OnHitTypes.Types.None

var hasOnHitEffect : bool = false

func _ready():
	set_scale(bulletScale)

func _physics_process(delta): 
	var movement = move_and_collide(vel.normalized() * delta * (speed * 10))

func _on_area_2d_area_entered(area):
	if area != null :
		(area.get_parent() as EnemyBase).TakeDamage(damage)
		speed = 0
		sprite.visible = false
		TriggerOnHit()

func TriggerOnHit() :
	
	#Disable base hitboxes
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	#Enable on-hit effects
	explosionHitbox.disabled = false
	projectileOnHitVFX.PlayAnimation()
	
	# Make the explosion hitbox and export ------
	# Make inheriters of this class as projectiles, make hitboxes for the onhit, and connect them
	#	to the export
	# Then remove the match switch case on the function above
	# make sure the animation works properly and despawn after animation ends
	# Give onHitType to the projectile through the turret script
	# Enable explosion hitbox after bullet hits, last as long as animation, 
	#	despawn everything after

func _on_projectile_on_hit_vfx_animation_finished():
	queue_free()
