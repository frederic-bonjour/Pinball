class_name QuestManager
extends RefCounted


signal quest_completed(name: StringName)
signal all_quests_completed

var _quests := {}  


class Quest:
	var name: StringName
	var progress: float = 0.0
	var count: int
	var step: float
	
	var completed: bool:
		get: return progress >= 1.0
	
	func _init(_name: StringName, _count: int):
		count = _count
		step = 1.0 / float(count)

	func add_step() -> float:
		progress += step
		return progress


func add_quest(name: StringName, count: int) -> Quest:
	if not _quests.has(name):
		_quests[name] = Quest.new(name, count)
	return _quests[name]


func quest_add_step(name: StringName) -> float:
	var q: Quest = _quests[name]
	if not q.completed:
		var p = q.add_step()
		if q.completed:
			quest_completed.emit(name)
			if check_all_quests_completed():
				all_quests_completed.emit()
		return p
	return 1.0


func quest_is_completed(name: StringName) -> bool:
	return _quests[name].completed


func check_all_quests_completed() -> bool:
	for name in _quests:
		if not _quests[name].completed:
			return false
	return true
