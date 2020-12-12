defmodule CodeGenerator do

  def generate_code(ast) do
    code = post_order(ast) #postorder traversal
    code
  end

  #posorder travesal at AST, cocatenates assembler code for each root node
  def post_order(node) do
    case node do
      nil ->                #When there isn't node
        ""

      ast_node ->

        code_snippet = post_order(ast_node.left_node)   #first, left travel
        post_order(ast_node.right_node)                 #right travel.
        emit_code(ast_node.node_name, code_snippet, ast_node.value) #calls every function emite_code, depending on the node name.


    end
  end

  #When first parameter is program node.
  def emit_code(:program, code_snippet, _) do
    """
        .section        __TEXT,__text,regular,pure_instructions
        .p2align        4, 0x90
    """ <>
      code_snippet                           #concateates with assembler code.
  end

  #When parameter is function node.
  def emit_code(:function, code_snippet, :main) do
    """
        .globl  _main         ## -- Begin function main
    _main:                    ## @main
    """ <>
      code_snippet                           #concatenates with assembler code.
  end

  #When first parameter is return node
  def emit_code(:return, code_snippet, _) do
    """
        movl    #{code_snippet}, %rax
        ret
    """
  end

  #When first parameter is constant node, this function will be called first.
  def emit_code(:constant, _code_snippet, value) do
    "$#{value}"                            #take value and puts it in the assembler code.
  end

end
