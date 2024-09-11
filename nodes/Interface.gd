extends CanvasLayer

@export var collected_coins: int = 0:
	set(value):
		$CoinLabel.text = " x %s" % value
		collected_coins = value
