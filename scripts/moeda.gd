extends Node2D
signal collect
@onready var animated_sprite_2d = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("default")



func _on_area_2d_area_entered(_area):
	collect.emit(self)
	queue_free()
