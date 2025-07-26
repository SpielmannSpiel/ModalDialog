@tool
extends EditorPlugin

const AUTOLOAD_NAME = "ModalDialogGlobal"

func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/ModalDialog/scenes/globals/modal_dialog_global.tscn")

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)
