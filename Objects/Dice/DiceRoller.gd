extends Node2D

class_name DiceRoller

signal finished_rolling

@export var anim : AnimatedSprite2D
@export var number_label : Label
@export var number_bg : Sprite2D
@export var visibility_timer : Timer

# Show animaton, unshow previous number result, restart timer, return roll value
func RollDice():
	visibility_timer.stop()
	
	number_label.visible = false
	number_bg.visible = false
	
	anim.visible = true
	anim.play()
	
	var randint = RandomNumberGenerator.new().randi_range(1,6)
	number_label.text = str(randint)
	return randint

# On animation finished, show dice result and unshow animation sprite
func _on_animated_sprite_2d_animation_finished():
	number_label.visible = true
	number_bg.visible = true
	anim.visible = false
	anim.stop()
	finished_rolling.emit()
	visibility_timer.start()

# Remove everything after a while if idle
func _on_remove_visibility_timer_timeout():
	number_label.visible = false
	number_bg.visible = false
	anim.visible = false
