module ast

pub const empty_name = ''
pub const empty_node = &AstNode{
	typ: .empty
	prev: 0
	next: 0
	parent: 0
	child: 0
}

pub fn new_node(typ NodeType, pos token.Pos) AstNode {
	return ast.AstNode{
		typ: typ
		pos: pos
	}
}

[heap]
pub struct AstNode {
pub:
	name string = empty_name
	typ NodeType
mut:
	pos token.Pos
	prev &AstNode = empty_node
	next &AstNode = empty_node
	parent &AstNode = empty_node
	child &AstNode = empty_node
}

pub fn (node &AstNode) child_count() int {
	mut cur_child := node.child
	mut len := 0

	for !cur_child.is_null() {
		len++
		cur_child = unsafe { cur_child.next }
	}

	return len
}

pub fn (node &AstNode) is_null() bool {
	return node == 0 || node == empty_node
}

pub fn (mut node AstNode) append(new_sib &AstNode) {
	if node.next.is_null() {
		node.next = new_sib
	} else {
		node.next.append(new_sib)
	}
}

pub fn (mut node AstNode) append_child(child &AstNode) {
	if node.child.is_null() {
		node.child = child
	} else {
		node.child.append(child)
	}
	node.pos.extend(child)
}

pub enum NodeType {
	empty 

	// misc
	error
	token
	comment_inline
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
	assert_stmt
	ast_stmt
	goto_stmt
	labeled_stmt
	comptime_stmt
	send_stmt
	hash_stmt
	expr_stmt
	for_stmt

	// statement-expressions
	if_expr
	match_stmt
	unsafe_stmt
	select_stmt
	lock_stmt
	// comptime_if_stmt

	// expression
	go_expr
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
	comptime_identifier
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