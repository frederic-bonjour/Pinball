class_name Utils
extends Node


static func get_board(node: Node) -> PinballBoard:
	return node.find_parent("Board")


static func format_number(value: int, separator: StringName = &" ") -> String:
	# Convertit le nombre en chaîne de caractères
	var number_string = str(value)
	# Vérifie si le nombre est négatif
	var is_negative = value < 0
	# Retire le signe négatif pour simplifier le formatage
	if is_negative:
		number_string = number_string.substr(1)
	# Inverse la chaîne pour traiter par groupes de 3 chiffres
	var reversed = number_string.reverse()
	# Insère des séparateurs tous les 3 caractères
	var formatted = ""
	for i in range(reversed.length()):
		if i > 0 and i % 3 == 0:
			formatted += separator
		formatted += reversed[i]
	# Ré-inverse la chaîne pour retrouver l'ordre initial
	formatted = formatted.reverse()
	# Ajoute à nouveau le signe négatif si nécessaire
	if is_negative:
		formatted = "-" + formatted
	return formatted
