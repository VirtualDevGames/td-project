extends CharacterBody2D

class_name ProjectileBase

@onready var sprite : Sprite2D = $Sprite2D

var onHitProperty : OnHitTypes.Types = OnHitTypes.Types.None
@onready var EffectExplosive = preload("res://Objects/Projectiles/Effect_Explosive.tscn")

var damage : int = 1
var on_hit_damage : int = 0
var explosion_damage : int = 0
var speed : float = 1
var targetLocation : Vector2
var vel = Vector2(0,0)
var bulletScale = Vector2(0.8 , 0.8)
var isActive = true
var is_effecting : bool
var hits_left = 0
@export var onHitType : OnHitTypes.Types

var enemies_previously_hit : Array[Node2D]

func _ready():
	set_scale(bulletScale)

func _physics_process(delta): 
	move_and_collide(vel.normalized() * delta * (speed * 10))

func _on_area_2d_area_entered(area):
	if(area.get_parent() as EnemyBase).IsAlive() \
	   && area.collision_layer != 32             \
	   && isActive :
		#isActive = false
		(area.get_parent() as EnemyBase).TakeDamage(damage)
		TriggerOnHit(area) 

func TriggerOnHit(area : Area2D) :
	match onHitProperty:
		OnHitTypes.Types.Explosive:
			var effect : Effect_Base = EffectExplosive.instantiate()
			add_child(effect)
			effect.global_position = global_position
			effect.effectDamage = explosion_damage
			effect.TriggerEffect()
			is_effecting = true
			if hits_left <= 0 :
				effect.despawnBullet.connect(DespawnBulletAfterEffectAnimation)
				speed = 0
				sprite.visible = false
		OnHitTypes.Types.Piercing:
			pass
		_:
			call_deferred("queue_free")
	if hits_left <= 0 :
		speed = 0
		sprite.visible = false
		if !is_effecting :
			call_deferred("queue_free")
	else :
		hits_left -= 1

func DespawnBulletAfterEffectAnimation() :
	call_deferred("queue_free")
