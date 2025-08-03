extends Node2D
class_name Tile

var type := "enemy"

var tiles = {
	"card": 0,
	"chance": 1,
	"enemy": 2,
	"boss": 3,
	"move": 4,
}

func _ready():
	$Sprite.frame = tiles[type]
