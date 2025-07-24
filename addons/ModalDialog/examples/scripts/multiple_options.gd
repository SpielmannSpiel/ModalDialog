extends Node

@export var options_single: ModalDialogOption
@export var options_3: Array[ModalDialogOption]
@export var options_4: Array[ModalDialogOption]
@export var answer_box: RichTextLabel

func show_single() -> void:
	ModalDialogGlobal.modal_dialog.show_dialog("OK", "Ok, cool cool.", [options_single])
	
func show_3() -> void:
	ModalDialogGlobal.modal_dialog.show_dialog("Your Opinion", "Hamsters are:", options_3)

func show_4() -> void:
	ModalDialogGlobal.modal_dialog.show_dialog(
		"QUIZ",
		"From which show is the following quote:\n\nYou know, the very powerful and the very stupid have one thing in common: they don’t alter their views to fit the facts. They alter the facts to fit their views.",
		options_4
	)
	
func users_choice(choice: ModalDialogOption) -> void:
	answer_box.text = choice._to_string()
