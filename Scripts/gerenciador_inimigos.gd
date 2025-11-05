extends Node2D

var inimigo_cena : PackedScene = preload("res://Enemy/Bloated/Bloated.tscn")
var spawn_points : Array[Marker2D]

func _ready():
	spawn_points.clear()
	
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)
			
	# 🎯 NOVA LÓGICA: Spawna um inimigo em CADA ponto de spawn encontrado
	spawnar_em_todos_os_pontos()


func spawnar_em_um_ponto(ponto_de_spawn: Marker2D):
	# Verificações de segurança (opcional, mas bom ter)
	if not inimigo_cena:
		print("Erro: A cena do inimigo não foi definida/carregada.")
		return

	# 🌟 Crie uma nova instância da cena do inimigo
	var novo_inimigo = inimigo_cena.instantiate()

	# Defina a posição do inimigo na posição do ponto de spawn fornecido
	novo_inimigo.global_position = ponto_de_spawn.global_position

	# Adicione o inimigo à cena atual
	add_child(novo_inimigo)


func spawnar_em_todos_os_pontos():
	if spawn_points.is_empty():
		print("Erro: Nenhum ponto de spawn encontrado.")
		return
	
	# Itera sobre o array e chama a função para cada um
	for ponto in spawn_points:
		spawnar_em_um_ponto(ponto)


# A função original que spawneria apenas um aleatório (agora não é mais chamada no _ready())
# func spawnar_inimigo_aleatorio():
# 	var ponto_aleatorio = spawn_points.pick_random()
# 	spawnar_em_um_ponto(ponto_aleatorio)
