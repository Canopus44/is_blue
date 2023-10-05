# FILEPATH: /home/canopus/Projects/Galactic_Equinox/Games/is_blue/scripts/Global.gd

# Este script define un nodo global que contiene variables y funciones
# relacionadas con el sistema de experiencia y nivel del jugador.
# Contiene constantes para la experiencia requerida por nivel y variables
# para el ataque actual del jugador, la experiencia actual y el nivel del jugador.

extends Node

# La cantidad de experiencia requerida para subir de nivel.
const EXPERIENCE_REQUIRED_PER_LEVEL = 100

# El estado actual del ataque del jugador.
var player_current_attack = false

# La cantidad de puntos de experiencia que el jugador tiene actualmente.
var player_xp = 0

# El nivel actual del jugador.
var player_level = 1

# Base de experiencia para cada enemigo.

var experience = 100

# Agrega puntos de experiencia a la experiencia actual del jugador y
# verifica si el jugador tiene suficiente experiencia para subir de nivel.
func gain_xp(xp):
	player_xp += xp
	print("¡Ganaste ", xp, " puntos de experiencia!")

	if player_xp >= EXPERIENCE_REQUIRED_PER_LEVEL:
		level_up()


# Aumenta el nivel del jugador y resta la experiencia requerida de
# la experiencia actual del jugador.
func level_up():
	player_level += 1
	player_xp -= EXPERIENCE_REQUIRED_PER_LEVEL
	print("¡Subiste de nivel! Nivel: ", player_level)


func random_experience(experience_base, experience_range):
	print("Base: ", experience_base, " Rango: ", experience_range)
	experience = experience_base * experience_range
	print("Experiencia: ", experience)
	var rng = RandomNumberGenerator.new()
	var my_random_experience = rng.randf_range(experience_base, experience)
	print("Número aleatorio: ", my_random_experience)
	
	return my_random_experience
