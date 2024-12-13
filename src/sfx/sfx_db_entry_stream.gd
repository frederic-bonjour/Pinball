@tool
class_name SfxDbEntryStream
extends Resource

## The sound file.
@export var stream: AudioStream

## Greater weight means higher probability for this sound file to be chosen.[br]
## If you want file [b]A[/b] to be chosen twice more often than file [b]B[/b], set [b]2[/b] for [b]A[/b] and [b]1[/b] for [b]B[/b].[br][br]
@export_range(1, 100) var weight: int = 1
