extends CanvasLayer

#@onready var button = $ColorRect/Button

func _ready():
	# A tela já está escondida por padrão no editor.
	# A conexão do sinal do botão continua aqui, pois é um bom lugar para fazê-la
	#button.pressed.connect(_on_button_click)
	pass


func show_death_screen():
	# Mostra a tela de morte e pausa o jogo
	show()
	get_tree().paused = true


func _on_button_pressed() -> void:
	# Primeiro, despausa o jogo
	get_tree().paused = false
	
	# Agora, reinicia o jogo
	get_tree().change_scene_to_file("res://Rooms/room0.tscn")
