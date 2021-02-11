defmodule CodeGenerator do

  def generate_code(ast) do
    code = post_order(ast, " ") #postorder traversal
    code
  end

  #posorder travesal at AST, cocatenates assembler code for each root node
  def post_order(node, code_snippet) do
    case node do
      nil ->                #When there isn't node
        ""

      ast_node ->

         if ast_node.node_name == :constant do
           emit_code(:constant, code_snippet, ast_node.value)
         else

           emit_code(
             ast_node.node_name,
             post_order(ast_node.left_node, code_snippet) <>
             pushOp(ast_node) <>
             post_order(ast_node.right_node, code_snippet) <>
             popOp(ast_node),
             ast_node.value
           )
         end
        #  code_snippet = post_order(ast_node.left_node)   #first, left travel
        #  post_order(ast_node.right_node)                 #right travel.
        #  emit_code(ast_node.node_name, code_snippet, ast_node.value) #calls every function emite_code, depending on the node name.


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

  #When fisrt parameter is return node
  def emit_code(:return, code_snippet, _) do
    code_snippet <>
    """
        ret
    """
  end

  #When first parameter is constant node, this function will be called first.
  def emit_code(:constant, _code_snippet, value) do
    """
        movl   #{value}, %rax
    """
  end

  #for unary operators
  def emit_code(:unary, code_snippet, :negation) do
    code_snippet <>
    """
        neg   %rax
    """
  end

  def emit_code(:unary, code_snippet, :logicalN) do
    code_snippet <>
    """
        cmpl   $0, %rax
        movl   $0, %rax
        sete   %al
    """
  end
  def emit_code(:unary, code_snippet, :bitW) do
    code_snippet <>
    """
        not    %rax
    """
  end

  #for binary operators
  def emit_code(:binary, code_snippet, :addition) do
    code_snippet <>
    """
        pop    %rax
        add    %rax, %rcx
    """
  end

  def emit_code(:binary, code_snippet, :negation) do
    code_snippet <>
    """
        sub    %rax, %rbx
        mov    %rbx, %rax
    """
  end

  def emit_code(:binary, code_snippet, :multiplication) do
    code_snippet <>
    """
        imul   %rbx, %rax
    """
  end

  def emit_code(:binary, code_snippet, :division) do
    code_snippet <>
    """
        push   %rax
        mov    %rbx, %rax
        pop    %rbx
        cqo
        idivq  %rbx
    """
  end

  #For even more binary operators
  def emit_code(:binary, code_snippet, :logicalAND) do
    first = Regex.scan(~r/clause_and\d{1,}/, code_snippet)
    second = Regex.scan(~r/clause_and\d{1,}/, code_snippet)
    num = Integer.to_string(length(first) + length(second) + 1)

    code_snippet <>
    """
        cmp   $0, %rax
        jne   clause_and#{num}
        jmp   end_and#{num}
      clause_and#{num}:
        cmp   $0,  %rax
        mov   $0,  %rax
        setne      %al
      end_and#{num}:
    """
  end

  def emit_code(:binary, code_snippet, :logicalOR) do
    first = Regex.scan(~r/clause_or\d{1,}/, code_snippet)
    second = Regex.scan(~r/clause_or\d{1,}/, code_snippet)
    num = Integer.to_string(length(first) + length(second) + 1)

    code_snippet <>
    """
        cmp   $0,  %rax
        je clause_or#{num}
        mov   $1,  %rax
        jmp   end_or#{num}:
      clause_or#{num}:
        cmp   $0, %rax
        mov   $0, %rax
        setne     %al
      end_or#{num}:

    """
  end

  def emit_code(:binary, code_snippet, :equalTo) do
    code_snippet <>
    """
        push   %rax
        pop    %rbx
        cmp    %rax, %rbx
        mov    $0,   %rax
        sete   %al
    """
  end

  def emit_code(:binary, code_snippet, :nEqualTo) do
    code_snippet <>
    """
        push   %rax
        pop    %rbx
        cmp    %rax, %rbx
        mov    $0, %rax
        setne  %al
    """
  end

  def emit_code(:binary, code_snippet, :lessThan) do
    code_snippet <>
    """
        push   %rax
        pop    %rbx
        cmp    %rax, %rbx
        mov    $0, %rax
        setl   %al
    """
  end

  def emit_code(:binary, code_snippet, :lessOrEqualTo) do
    code_snippet <>
    """
        push   %rax
        pop    %rbx
        cmp    %rax, %rbx
        mov    $0, %rax
        setle  %al
    """
  end

  def emit_code(:binary, code_snippet, :greaterThan) do
    code_snippet <>
    """
        push   %rax
        pop    %rbx
        cmp    %rax, %rbx
        mov    $0
        setg   %al
    """
  end

  def emit_code(:binary, code_snippet, :greaterThanOrEqualTo) do
    code_snippet <>
    """
        push   %rax
        pop    %rbx
        cmp    %rax, %rbx
        mov    $0, %rax
        setge  %al
    """
  end

  #secondary_functions
  def pushOp(ast_node) do
    if ast_node.node_name == :unary and ast_node.value == :negation and ast_node.right_node == nil do
      """
          _NEG
      """
    else
      """
          push   %rax
      """
    end
  end

  def popOp(ast_node) do
    if ast_node.node_name == :unary and ast_node.value == :negation and ast_node.right_node == nil do
      ""
    else
      """
          pop    %rbx
      """
    end
  end
end
