@tool
extends EditorPlugin

func _enter_tree() -> void:
		add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UR, TextEdit.new())
