extends Node


func do_throw(character : SGCharacterBody2D):
	character.Transitioned.emit(self, "thrower")

func do_fireball(character : SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.Transitioned.emit(self, "hadou")

func do_5A(character : SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_5a"
	character.Transitioned.emit(self, "attack")

func do_5B(character : SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_5b"
	character.Transitioned.emit(self, "attack")

func do_5C(character : SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_5c"
	character.Transitioned.emit(self, "attack")

func do_2A(character : SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_2a"
	character.Transitioned.emit(self, "attack")

func do_2B(character : SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_2b"
	character.Transitioned.emit(self, "attack")

func do_2C(character : SGCharacterBody2D):
	character.low_blocking = false
	character.high_blocking = false
	character.movename = "grappler_2c"
	character.Transitioned.emit(self, "attack")
