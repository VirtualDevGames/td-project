extends CharacterBody2D

class_name ProjectileBase

@onready var sprite : Sprite2D = $Sprite2D
@export var explosionHitbox : CollisionShape2D

var onHitProperty : OnHitTypes.Types = OnHitTypes.Types.None
@onready var EffectExplosive = preload("res://Objects/Scripts and Scenes/Projectiles/Effect_Explosive.tscn")

var damage : int = 1
var effectDamage : int = 0
var speed : float = 1
var targetLocation : Vector2
var vel = Vector2(0,0)
var bulletScale = Vector2(0.8 , 0.8)
@export var onHitType : OnHitTypes.Types

var hasOnHitEffect : bool = false

func _ready():
	set_scale(bulletScale)

func _physics_process(delta): 
	move_and_collide(vel.normalized() * delta * (speed * 10))

func _on_area_2d_area_entered(area):
	if area != null :
		(area.get_parent() as EnemyBase).TakeDamage(damage)
		speed = 0
		sprite.visible = false
		call_deferred("TriggerOnHit")

func TriggerOnHit() :
	match onHitProperty:
		OnHitTypes.Types.Explosive:
			var effect : Effect_Base = EffectExplosive.instantiate()
			add_child(effect)
			effect.global_position = global_position
			effect.TriggerEffect()
			effect.despawnBullet.connect(DespawnBulletAfterEffectAnimation)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)

func DespawnBulletAfterEffectAnimation() :
	call_deferred("queue_free")
