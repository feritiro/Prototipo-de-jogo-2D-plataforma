extends AudioStreamPlayer

var fade_duration = 10.0  # Tempo em segundos para o fade-out
var tween : Tween

func _ready():
	# Inicie a reprodução da música
	play()

	# Criar o nó Tween
	tween = Tween.new()
	add_child(tween)

	# Conecte o sinal 'tween_completed' ao método '_on_fade_out_completed'
	tween.connect("tween_completed", self, "_on_fade_out_completed")

# Função para iniciar o fade-out usando Tween
func start_fade_out():
	# Adicione um interpolate_property ao Tween
	tween.interpolate_property(self, "volume_db", get_volume_db(), -80.0, fade_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	# Inicie o Tween
	tween.start()

# Método chamado quando o Tween de fade-out é concluído
func _on_fade_out_completed(object, key):
	# Faça algo quando o fade-out for concluído (opcional)
	pass


func _on_FireDemonBoss_BossDead():
	start_fade_out()
