extends Label

var new_text = false

func _physics_process(_delta: float) -> void:
	if self_modulate.a > 0:
		#print(self_modulate.a)
		self_modulate.a -= 0.01
