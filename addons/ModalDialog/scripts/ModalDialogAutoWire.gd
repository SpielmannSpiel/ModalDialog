class_name ModalDialogAutoWire
extends Node

signal dialog_chosen(selected_option: ModalDialogOption)

enum AutoWireTargetEn {
	GLOBAL,
	LOCAL_DIALOG
}

@export var auto_wire_to: AutoWireTargetEn = AutoWireTargetEn.GLOBAL
@export var local_dialog: ModalDialog

func _ready() -> void:
	match auto_wire_to:
		AutoWireTargetEn.GLOBAL:
			ModalDialogGlobal.modal_dialog.dialog_chosen.connect(chosen)
		AutoWireTargetEn.LOCAL_DIALOG:
			local_dialog.dialog_chosen.connect(chosen)

func chosen(modal_option: ModalDialogOption) -> void:
	dialog_chosen.emit(modal_option)

func _exit_tree() -> void:
	match auto_wire_to:
		AutoWireTargetEn.GLOBAL:
			ModalDialogGlobal.modal_dialog.dialog_chosen.disconnect(chosen)
		AutoWireTargetEn.LOCAL_DIALOG:
			local_dialog.dialog_chosen.disconnect(chosen)
