class_name ModalDialogButton
extends Button

signal chosen(modal_option: ModalDialogOption)

@export var modal_option: ModalDialogOption

func _enter_tree() -> void:
	pressed.connect(_chosen)

func load_data() -> void:
	set_data(modal_option)

func set_data(_modal_option: ModalDialogOption) -> void:
	modal_option = _modal_option
	text = modal_option.option_label

func _chosen() -> void:
	chosen.emit(modal_option)
