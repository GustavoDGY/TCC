extends HBoxContainer

@onready var player_node = $"../../Player" # Certifique-se de que o caminho para o seu Player está correto!

func _ready():
	# Conecta o sinal personalizado do jogador para atualizar a UI
	player_node.vida_mudou.connect(_on_player_vida_mudou)
	# Atualiza a UI inicial para refletir a vida atual
	_on_player_vida_mudou(player_node.vida)

func _on_player_vida_mudou(nova_vida: int):
	# Lógica para mostrar ou esconder corações, ou atualizar o texto
	for i in range(get_child_count()):
		var heart_node = get_child(i)
		if i < nova_vida:
			heart_node.visible = true
		else:
			heart_node.visible = false

	# Se estiver usando um Label, você pode fazer algo assim:
	var label_node = get_child(0)
	label_node.text = "Vida: " + str(nova_vida)
