class_name ModalDialog
extends Control

enum AutoWidthEn {
	OFF,
	MANUAL,
	QUARTER_SCREEN,
	THIRD_SCEEN,
	HALF_SCEEEN
}

enum SeparatorDirectionEn {
	NONE = 0,
	HORIZONTAL = 2,
	VERTICAL = 4,
	HORIZONTAL_VERTICAL = 6
}

signal dialog_shown()
signal dialog_hidden()
signal dialog_chosen(selected_option: ModalDialogOption)

## Hides the dialog when the user picked an option.[br]
## Disable this to do it manually.
@export var auto_hide: bool = true
## Automatically calls the attached callable function[br]
## (option_function_call) of an option.
@export var auto_call_option_function: bool = true
@export var auto_width: AutoWidthEn = AutoWidthEn.QUARTER_SCREEN
@export_flags("Horizontal:2", "Vertical:4") var add_separators: int = 6
@export var max_width: int = 0
@export var dialog_title: Label
@export var dialog_text: RichTextLabel
@export var button_target: Control
@export var size_container: Control

var _options: Array[ModalDialogOption]

func _enter_tree() -> void:
	hide_dialog()

func _set_width() -> void:
	# TODO: on resize
	var width_size = 0
	var window_size = get_window().size
	
	match auto_width:
		AutoWidthEn.QUARTER_SCREEN:
			width_size = window_size.x / 4
			dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		AutoWidthEn.THIRD_SCEEN:
			width_size = window_size.x / 3
			dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		AutoWidthEn.HALF_SCEEEN:
			width_size = window_size.x / 2
			dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		AutoWidthEn.MANUAL:
			width_size = width_size
			dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		AutoWidthEn.OFF:
			dialog_text.autowrap_mode = TextServer.AUTOWRAP_OFF
	
	size_container.custom_minimum_size.x = width_size

func show_dialog_plain() -> void:
	visible = true
	dialog_shown.emit()

func show_dialog(title: String, text: String, options: Array[ModalDialogOption]) -> void:
	_options = options
	dialog_title.text = title
	dialog_text.text = text
	
	_create_buttons()
	visible = true
	_set_width()
	
	dialog_shown.emit()

func hide_dialog() -> void:
	visible = false
	dialog_hidden.emit()
	
func chosen(modal_option: ModalDialogOption) -> void:
	dialog_chosen.emit(modal_option)
	
	if not modal_option.option_function_call.is_null():
		modal_option.option_function_call.call(modal_option)
	
	if not modal_option.option_function_call_no_params.is_null():
		modal_option.option_function_call_no_params.call()
	
	if auto_hide:
		hide_dialog()

func _create_buttons() -> void:
	_clear_children(button_target)
	
	if _options.size() == 1:
		_create_buttons_1()
	elif _options.size() == 2:
		_create_buttons_2()
	elif _options.size() == 4:
		_create_buttons_4()
	else:
		_create_buttons_list()

func _clear_children(target: Node) -> void:
	for child in target.get_children():
		child.queue_free()
		
func add_new_button(option: ModalDialogOption, target: Node) -> void:
	var button: ModalDialogButton = ModalDialogButton.new()
	button.set_data(option)
	button.chosen.connect(chosen)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	target.add_child(button)
	button.owner = target

func add_new_separator(direction: SeparatorDirectionEn, target: Node) -> void:
	#if add_separators == SeparatorDirectionEn.NONE:
	#	return
	
	#if not direction & add_separators:
	#	return
	
	var separator: Control
	match direction:
		SeparatorDirectionEn.HORIZONTAL:
			separator = HSeparator.new()
		SeparatorDirectionEn.VERTICAL:
			separator = VSeparator.new()
	
	target.add_child(separator)
	separator.owner = target

func add_new_dummy(target: Node) -> void:
	var dummy: Control = Control.new()
	target.add_child(dummy)
	dummy.owner = target

func _create_buttons_1() -> void:
	add_new_button(_options[0], button_target)

func _create_buttons_2() -> void:
	var container: HBoxContainer = HBoxContainer.new()
	button_target.add_child(container)
	container.owner = button_target
	
	add_new_button(_options[0], container)
	add_new_separator(SeparatorDirectionEn.VERTICAL, container)
	add_new_button(_options[1], container)

func _create_buttons_4() -> void:
	var container: GridContainer = GridContainer.new()
	button_target.add_child(container)
	container.owner = button_target
	
	container.columns = 2
	if SeparatorDirectionEn.VERTICAL & add_separators:
		container.columns = 3
	
	add_new_button(_options[0], container)
	if SeparatorDirectionEn.VERTICAL & add_separators:
		add_new_separator(SeparatorDirectionEn.VERTICAL, container)
	add_new_button(_options[1], container)
	
	if SeparatorDirectionEn.HORIZONTAL & add_separators:
		add_new_separator(SeparatorDirectionEn.HORIZONTAL, container)
		if SeparatorDirectionEn.VERTICAL & add_separators:
			add_new_dummy(container)
		add_new_separator(SeparatorDirectionEn.HORIZONTAL, container)
	
	add_new_button(_options[2], container)
	if SeparatorDirectionEn.VERTICAL & add_separators:
		add_new_separator(SeparatorDirectionEn.VERTICAL, container)
	add_new_button(_options[3], container)

func _create_buttons_list() -> void:
	var container: VBoxContainer = VBoxContainer.new()
	button_target.add_child(container)
	container.owner = button_target
	
	var loop_index: int = 0
	var loop_index_max: int = _options.size() - 1
	
	for option in _options:
		add_new_button(option, container)
		if SeparatorDirectionEn.HORIZONTAL & add_separators:
			if loop_index < loop_index_max:
				add_new_separator(SeparatorDirectionEn.HORIZONTAL, container)
		
		loop_index += 1
