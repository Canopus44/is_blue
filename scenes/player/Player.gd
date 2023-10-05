# FILEPATH: /home/canopus/Projects/Galactic_Equinox/Games/is_blue/scenes/player/Player.gd

extends CharacterBody2D

# Constantes de movimiento
const SPEED = 100.0  # Velocidad de movimiento del jugador

# Variables de estado del jugador
var enemy_in_attack_range = false  # Indica si hay un enemigo en rango de ataque
var enemy_attack_cooldown = true  # Indica si el enemigo está en cooldown de ataque
@export var health = 100  # Salud actual del jugador
var player_alive = true  # Indica si el jugador está vivo


# Variables de movimiento
var current_direction = Vector2(0, 0)  # Dirección actual del jugador
var last_direction = Vector2(0, 0)  # Última dirección válida del jugador

# Variables de ataque
var attack_in_progress = false  # Indica si el jugador está en proceso de ataque
var current_xp = Global.player_xp  # Experiencia actual del jugador
var current_level = Global.player_level  # Nivel actual del jugador

# Referencia al sprite animado del jugador
@onready var anim = $AnimatedSprite2D


# Función que se ejecuta en cada cuadro
func _physics_process(_delta):
	player_movement(_delta)
	enemy_attack()
	player_attack()

	# Verifica si el jugador ha muerto
	if health <= 0:
		player_alive = false
		health = 0
		print("Player is dead")
		self.queue_free()


# Función que maneja el movimiento del jugador
func player_movement(_delta):
	current_direction = Vector2(0, 0)  # Restablece la dirección actual en cada cuadro

	# Verifica las teclas presionadas y actualiza la dirección actual
	if Input.is_action_pressed("move_right"):
		current_direction.x += 1
	if Input.is_action_pressed("move_left"):
		current_direction.x -= 1
	if Input.is_action_pressed("move_up"):
		current_direction.y -= 1
	if Input.is_action_pressed("move_down"):
		current_direction.y += 1

	# Normaliza la dirección si se están presionando múltiples teclas a la vez
	if current_direction.length() > 0:
		current_direction = current_direction.normalized()

	# Asigna la velocidad basada en la dirección actual
	velocity = current_direction * SPEED

	# Mueve al jugador y lo hace colisionar con el mundo
	move_and_slide()

	# Determina la animación según la dirección actual
	play_animation(current_direction)


# Función que maneja la animación del jugador
func play_animation(direction):
	if attack_in_progress == false:
		if direction.x > 0:
			anim.play("iso_run_right")
			last_direction = Vector2(1, 0)
		elif direction.x < 0:
			anim.play("iso_run_left")
			last_direction = Vector2(-1, 0)
		elif direction.y > 0:
			anim.play("iso_run_down")
			last_direction = Vector2(0, 1)
		elif direction.y < 0:
			anim.play("iso_run_up")
			last_direction = Vector2(0, -1)
		else:
			# Si no se está moviendo, reproduce la animación de "idle" en la última dirección válida
			if last_direction.x > 0:
				anim.play("iso_idle_right")
			elif last_direction.x < 0:
				anim.play("iso_idle_left")
			elif last_direction.y > 0:
				anim.play("iso_idle_down")
			elif last_direction.y < 0:
				anim.play("iso_idle_up")
			else:
				# Si no se ha movido en ninguna dirección, usa una animación predeterminada
				anim.play("iso_idle_down")


# Función que se ejecuta cuando el hitbox del jugador colisiona con otro cuerpo
func _on_player_hitbox_body_entered(body: Node2D):
	if body.has_method("enemy"):
		print("Enemy in attack range")
		enemy_in_attack_range = true


# Función que se ejecuta cuando el hitbox del jugador deja de colisionar con otro cuerpo
func _on_player_hitbox_body_exited(body: Node2D):
	if body.has_method("enemy"):
		print("Enemy out of attack range")
		enemy_in_attack_range = false


# Función que maneja el ataque del enemigo
func enemy_attack():
	if enemy_in_attack_range && enemy_attack_cooldown == true:
		health -= 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


# Función que maneja el ataque del jugador
func player_attack():
	var direction = current_direction

	if Input.is_action_just_pressed("player_attack"):
		Global.player_current_attack = true
		attack_in_progress = true
		if direction.x > abs(direction.y):
			print("Attack right")
			anim.play("iso_attack_right")
			last_direction = Vector2(1, 0)
			$deal_attack_timer.start()
		elif -direction.x > abs(direction.y):
			print("Attack left")
			anim.play("iso_attack_left")
			last_direction = Vector2(-1, 0)
			$deal_attack_timer.start()
		elif direction.y > abs(direction.x):
			print("Attack down")
			anim.play("iso_attack_down")
			last_direction = Vector2(0, 1)
			$deal_attack_timer.start()
		elif -direction.y > abs(direction.x):
			print("Attack up")
			anim.play("iso_attack_up")
			last_direction = Vector2(0, -1)
			$deal_attack_timer.start()
		else:
			# Si no se está moviendo, reproduce la animación de "idle" en la última dirección válida
			if last_direction.x > abs(direction.y):
				anim.play("iso_attack_right")
				$deal_attack_timer.start()
			elif -last_direction.x > abs(direction.y):
				anim.play("iso_attack_left")
				$deal_attack_timer.start()
			elif last_direction.y > abs(direction.x):
				anim.play("iso_attack_down")
				$deal_attack_timer.start()
			elif -last_direction.y > abs(direction.x):
				anim.play("iso_attack_up")
				$deal_attack_timer.start()
			else:
				# Si no se ha movido en ninguna dirección, usa una animación predeterminada
				anim.play("iso_idle_down")
				$deal_attack_timer.start()


# Función que se ejecuta cuando el temporizador de cooldown de ataque del enemigo termina
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


# Función que se ejecuta cuando el temporizador de ataque del jugador termina
func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_in_progress = false
