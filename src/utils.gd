class_name Utils
extends Node


static func get_board(node: Node) -> PinballBoard:
	return node.find_parent("Board")
