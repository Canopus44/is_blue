# FILEPATH: /home/canopus/Projects/Galactic_Equinox/Games/is_blue/scenes/enemies/Slime.gd

# Extiende la clase CharacterBody2D para crear un enemigo tipo "slime".
extends CharacterBody2D

# Velocidad a la que se mueve el enemigo.
const SPEED = 50

# Indica si el enemigo está persiguiendo al jugador.
var player_chase = false

# Referencia al jugador.
var player = null

# Stats del enemigo.
var health = 100
var experience = Global.random_experience(100,2)

# Indica si el jugador está dentro del rango de ataque del enemigo.
var player_in_attack_zone = false

# Indica si el enemigo puede recibir daño.
var can_take_damage = true

# Referencia al sprite animado del enemigo.
@onready var anim = $AnimatedSprite2D


# Función que se ejecuta en cada frame.
func _physics_process(delta):
	deal_with_damage()

	# Si el enemigo está persiguiendo al jugador, se mueve hacia él.
	if player_chase:
		position = position.move_toward(player.position, SPEED * delta)

		# Si el jugador está a la izquierda del enemigo, se voltea el sprite horizontalmente.
		if player.position.x < position.x:
			anim.flip_h = true
		else:
			anim.flip_h = false

	# Si el enemigo no está persiguiendo al jugador, se reproduce la animación de "idle".
	else:
		anim.play("idle")


# Función que se ejecuta cuando un cuerpo entra en el área de detección del enemigo.
func _on_detection_area_body_entered(body: Node2D):
	# Cuando el jugador entra en el área de detección del enemigo,
	#se guarda su referencia y se activa la persecución.
	player = body
	player_chase = true
	anim.play("walk")


# Función que se ejecuta cuando un cuerpo sale del área de detección del enemigo.
func _on_detection_area_body_exited(_body: Node2D):
	# Cuando el jugador sale del área de detección del enemigo,
	#se borra su referencia y se detiene la persecución.
	player = null
	player_chase = false
	anim.play("idle")


# Función que se ejecuta cuando un cuerpo entra en el área de ataque del enemigo.
func _on_enemy_hitbox_body_entered(body: Node):
	if body.has_method("player_attack"):
		print("Player in range to attack")
		player_in_attack_zone = true


# Función que se ejecuta cuando un cuerpo sale del área de ataque del enemigo.
func _on_enemy_hitbox_body_exited(body: Node):
	if body.has_method("player_attack"):
		print("Enemy out of attack range")
		player_in_attack_zone = false


# Función que se encarga de manejar el daño recibido por el enemigo.
func deal_with_damage():	
	if player_in_attack_zone && Global.player_current_attack == true:		
		if can_take_damage:
			health -= 15
			$take_damage_cooldown.start()
			can_take_damage = false
			print("Slime health :", health)
			if health <= 0:
				anim.play("death")
				_on_death()
				self.queue_free()
				print("Slime died")


# Función que se ejecuta cuando termina el tiempo de espera para recibir daño.
func _on_take_damage_cooldown_timeout():
	can_take_damage = true


# Función que no hace nada.
func enemy():
	pass


# Función que se ejecuta cuando el enemigo muere.
func _on_death():
	# Llama a la función para que el personaje gane experiencia.
	Global.gain_xp(experience)
