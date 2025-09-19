extends Camera2D


func _ready():
	set_limite()
	

func set_limite():
	var root = get_tree().current_scene
	var walls : TileMapLayer = root.get_node("Background/Auxiliar/Walls")
	
	if (walls == null): return #Se o player começar fora de uma cena, não crasha
	
	#Limite nos retorna a quandidade de tiles em x e y
	var limite = walls.get_used_rect().size
	
	#16 é o valor padrão de um tile
	var tile_size = 16
	
	self.limit_enabled = true
	self.limit_left = -tile_size
	self.limit_top = 0
	self.limit_right = (limite.x * tile_size) + tile_size
	self.limit_bottom = limite.y - tile_size
