extends Node2D

# Use "export" para facilitar a configuração no editor Godot
@export var inimigo_cena : PackedScene

# A lista de nós Marker2D que são os pontos de spawn
var spawn_points : Array[Marker2D]

func _ready():
	# Clear the array first to be safe
	spawn_points.clear()
	
	# Iterate through all children of this node
	for child in get_children():
		# Check if the child is a Marker2D
		if child is Marker2D:
			# Add it to our array of spawn points
			spawn_points.append(child)
			
	# Now you can proceed with spawning
	spawnar_inimigo_aleatorio()

func spawnar_inimigo_aleatorio():
	# Verifique se a cena do inimigo foi carregada
	if not inimigo_cena:
		print("Erro: A cena do inimigo não foi definida.")
		return

	# Verifique se existem pontos de spawn
	if spawn_points.is_empty():
		print("Erro: Nenhum ponto de spawn encontrado.")
		return

	# Escolha um ponto de spawn aleatoriamente
	var ponto_aleatorio = spawn_points.pick_random()

	# Crie uma nova instância da cena do inimigo
	var novo_inimigo = inimigo_cena.instantiate()

	# Defina a posição do inimigo na posição do ponto de spawn escolhido
	novo_inimigo.global_position = ponto_aleatorio.global_position

	# Adicione o inimigo à cena atual
	add_child(novo_inimigo)
