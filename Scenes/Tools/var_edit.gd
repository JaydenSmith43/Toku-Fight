extends LineEdit

@export var key : String

func _ready():
	text_submitted.connect(
		Callable(get_parent().get_parent().get_parent().get_parent().get_parent(), "_on_var_edit").bind(key)
	)
