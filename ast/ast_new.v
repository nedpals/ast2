module ast

[heap]
pub struct AstNode {
pub:
	typ NodeType
mut:
	pos token.Pos
	prev &Node = 0
	next &Node = 0
	parent &Node = 0
	child &Node = 0
}

pub enum NodeType {
	error

	// misc
	token
	comment_single
	comment_multi

	// root node
	root

	// top-level declarations
	module_decl
	import_decl
	struct_decl
	enum_decl
	fn_decl
	const_decl
	global_decl
	type_decl
	interface_decl

	// symbol annotations
	attribute_decl
	attribute_value

	// statements
	block
	assign_stmt
	var_decl
	increment_stmt
	decrement_stmt
	continue_stmt
	break_stmt
	return_stmt
	defer_stmt
	go_stmt
	assert_stmt
	ast_stmt
	goto_stmt
	labeled_stmt
	// TODO: comptime_stmt
	send_stmt
	hash_stmt
	expr_stmt

	// statement-expressions
	if_stmt
	match_stmt
	unsafe_stmt
	select_stmt
	lock_stmt
	// comptime_if_stmt

	// expression
	unary_expr // !t, ...t
	binary_expr // 1 + 1, 2 - 2, a is b
	call_expr
	index_expr
	slice_expr
	selector_expr
	short_selector_expr // for enum values (e.g. .red, .blue)
	paren_expr
	call_cast_expr
	as_cast_expr
	or_expr

	// block-ish exprs
	sql_expr

	// literal exprs
	map_literal
	array_literal
	fixed_array_literal
	bool_literal
	int_literal
	float_literal
	rune_literal
	identifier
	type_init // struct_init, array_init, etc

	// string literal exprs
	interp_string_literal
	c_string_literal
	raw_string_literal

	// type nodes
	type_node

	type_ident
	array_type
	fixed_array_type
	function_type
	map_type
	
	option_type
	generic_type
	imported_type
	pointer_type
	channel_type
	shared_type
	thread_type

	// for enum_decl
	enum_field

	// for struct_decl
	struct_field

	// for fn_decl and fn_literal
	parameter_list
	parameter

	// for type_init
	type_init_field

	// for string literals
	string_content

	// for call_expr
	argument_list
}