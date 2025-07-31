extends Node

@export var options: Array[ModalDialogOption]
@export var options_direct: Array[ModalDialogOption]
@export var answer_box: RichTextLabel

func _ready() -> void:
	ModalDialogGlobal.modal_dialog.dialog_chosen.connect(chosen)

func _exit_tree() -> void:
	# disconnect the signal
	ModalDialogGlobal.modal_dialog.dialog_chosen.disconnect(chosen)

func show_dialog_global_simple() -> void:
	ModalDialogGlobal.modal_dialog.show_dialog(
		"Question (Global)",
		"Do you like Hamsters?",
		options
	)

func show_dialog_global_direct() -> void:
	options_direct[0].option_function_call_no_params = Callable(self, "chosen_yes")
	options_direct[1].option_function_call_no_params = Callable(self, "chosen_no")	

	ModalDialogGlobal.modal_dialog.show_dialog(
		"Question (Global, direct)",
		"Do you like Hamsters?",
		options_direct
	)

func chosen_yes() -> void:
	answer_box.text += "You gave chosen wisely 🐹"
	
func chosen_no() -> void:
	answer_box.text += "GET OF MY LAWN!"
	
func chosen(selected_option: ModalDialogOption) -> void:
	print(selected_option)
	answer_box.text = "chosen:\n" + selected_option.to_string() + "\n\n"
	
	if not selected_option.option_function_call_no_params.is_null():
		selected_option.option_function_call_no_params.call()
