@tool
class_name SfxDbEntryFile
extends Resource

## The sound file.
@export_file("*.mp3", "*.wav", "*.ogg") var file: String

## Greater weight means higher probability for this sound file to be chosen.[br]
## If you want file A to be chosen twice more often than file B, set 2 for A and 1 for B.[br][br]
## [b]Note[/b]: keep this value as low as possible.
@export_range(1, 100) var weight: int = 1
