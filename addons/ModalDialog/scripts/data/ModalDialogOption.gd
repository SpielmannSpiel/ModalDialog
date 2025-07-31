class_name ModalDialogOption
extends Resource

@export var option_label: String = ""
@export var option_data: String = ""
var option_data_payload
var option_function_call: Callable
var option_function_call_no_params: Callable

func _to_string():
	return "Data: '%s' Label: '%s' Payload: '%s'" % [
			option_data,
			option_label,
			str(option_data_payload)
		]
