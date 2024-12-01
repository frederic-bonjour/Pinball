@tool
class_name ModularWall
extends StaticBody2D

@export var properties: WallProperties:
	set(v):
		properties = v
		_update_properties()

@export var start_joint_properties: WallJointProperties:
	set(v):
		if v:
			start_joint_properties = v
			start_joint_properties.connect(&"property_changed", _update_start_joint)
		else:
			start_joint_properties.disconnect(&"property_changed", _update_start_joint)
			start_joint_properties = v
		_update_start_joint(&"")

@export var end_joint_properties: WallJointProperties:
	set(v):
		if v:
			end_joint_properties = v
			end_joint_properties.connect(&"property_changed", _update_end_joint)
		else:
			end_joint_properties.disconnect(&"property_changed", _update_end_joint)
			end_joint_properties = v
		_update_end_joint(&"")


@onready var cs_capsule: CollisionShape2D = $CSCapsule
@onready var cs_rectangle: CollisionShape2D = $CSRectangle

var radius: float:
	get: return properties.thickness / 2.0

var half_length: float:
	get: return properties.length / 2.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group(&"walls")
	properties.connect(&"property_changed", _update_ui)
	_update_collision_shape()
	_update_body()


func _update_properties() -> void:
	_update_collision_shape()
	queue_redraw()


func _update_start_joint(_name: StringName) -> void:
	_update_joint("StartJoint", start_joint_properties, -half_length)

func _update_end_joint(_name: StringName) -> void:
	_update_joint("EndJoint", end_joint_properties, half_length)


func _update_joint(joint_name: String, props: WallJointProperties, p: float) -> void:
	if properties:
		var wjn: WallJoint = get_node_or_null(joint_name)
		if not wjn:
			var wjs = load("res://src/objects/board/wall_joint.tscn")
			wjn = wjs.instantiate()
			wjn.name = joint_name
			add_child(wjn)
			wjn.position.y = p
			wjn.position.x = 0.0
		wjn.properties = props
	else:
		var wjn: WallJoint = get_node_or_null(joint_name)
		if wjn:
			remove_child(wjn)
			wjn.queue_free()


func _update_joints_position() -> void:
	var wjn: WallJoint
	wjn = get_node_or_null("StartJoint")
	if wjn:
		wjn.position.y = -half_length
	wjn = get_node_or_null("EndJoint")
	if wjn:
		wjn.position.y = half_length


func _update_ui(prop_name: StringName) -> void:
	match prop_name:
		&"color", \
		&"rounded":
			queue_redraw()

		&"length", \
		&"thickness", \
		&"collision_rounded", \
		&"adjust_collision_margin":
			_update_joints_position()
			_update_collision_shape()
			queue_redraw()

		&"physics_material":
			_update_body()


func _update_collision_shape() -> void:
	if is_node_ready():
		if properties.collision_rounded:
			cs_capsule.disabled = false
			cs_rectangle.disabled = true
			var shape: CapsuleShape2D = cs_capsule.shape
			shape.height = properties.length + properties.adjust_collision_margin.y
			shape.radius = radius + properties.adjust_collision_margin.x
		else:
			cs_capsule.disabled = true
			cs_rectangle.disabled = false
			var shape: RectangleShape2D = cs_rectangle.shape
			shape.size.x = properties.thickness + properties.adjust_collision_margin.x
			shape.size.y = properties.length + properties.adjust_collision_margin.y
		cs_capsule.visible = not cs_capsule.disabled
		cs_rectangle.visible = not cs_rectangle.disabled


func _update_body() ->void:
	if is_node_ready():
		self.physics_material_override = properties.physics_material


func _draw() -> void:
	if properties.rounded:
		var y1 = -half_length + radius
		var y2 = half_length - radius
		if not start_joint_properties:
			draw_circle(Vector2(0, y1), radius, properties.color, true, -1.0, true)
		if not end_joint_properties:
			draw_circle(Vector2(0, y2), radius, properties.color, true, -1.0, true)
		draw_rect(Rect2(-radius, y1, properties.thickness, properties.length - properties.thickness), properties.color, true, -1.0, true)
	else:
		var offset_start: float = 0.0 if not start_joint_properties else radius
		var offset_end: float = 0.0 if not end_joint_properties else radius
		draw_rect(Rect2(-radius, -half_length + offset_start, properties.thickness, properties.length - offset_start - offset_end), properties.color, true, -1.0, true)
