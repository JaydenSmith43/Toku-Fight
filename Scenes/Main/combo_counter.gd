extends RichTextLabel
class_name ComboCounter

var on_screen_timer : float = 0
var timer_active : bool = true
@export var player : SGCharacterBody2D
@export var feedback_label : RichTextLabel

func _physics_process(delta: float) -> void:
	if on_screen_timer > 0 and timer_active:
		on_screen_timer -= delta
		
		if on_screen_timer <= 0:
			modulate = Color.TRANSPARENT

func combo_end():
	if (on_screen_timer > 0):
		modulate = Color.WEB_GRAY
		timer_active = true

func increase_combo_counter():
	if (player.combo > 1):
		set_combo_text()
		on_screen_timer = 0.5
		modulate = Color.WHITE
		timer_active = false

func set_combo_text():
	text = "[font_size={100}]" + str(player.combo) + "[/font_size][font_size={50}]HIT[/font_size]"
