extends Node2D

@onready var coin_label = $Interface/CoinLabel
@onready var coins = $Coins
@onready var game_over_screen = $Interface/LevelCompleteScreen
@export var next_level: PackedScene

var coin_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


#region ops Não tinha visto esse código kkkkk
# O importante é que tá resolvido
#func _on_coin_collect(_node):
	#coin_count += 1
	#coin_label.clear()
	#
	#coin_label.add_text(" x " + str(coin_count))
#endregion


func _on_porta_game_complete():
	game_over_screen.show()
	pass # Replace with function body.


func _on_button_pressed():
	if not next_level:
		printerr("oops, a porta não vai pra lugar nenum!")
	get_tree().change_scene_to_packed(next_level)
