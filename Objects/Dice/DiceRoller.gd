extends Node2D

class_name DiceRoller

@export var anim : AnimatedSprite2D
@export var number_label : Label
@export var number_bg : Sprite2D

func RollDice():
	anim.play()
	var rng = RandomNumberGenerator.new()
	var randint = rng.randi_range(1, 6)
	number_label.text = str(randint)
	return randint

func _on_animated_sprite_2d_animation_finished():
	#RollDice()
	number_label.visible = true
	number_bg.visible = true
	anim.visible = false
	anim.stop()
