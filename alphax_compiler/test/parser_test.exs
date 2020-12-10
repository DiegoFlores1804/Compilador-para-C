defmodule ParserTest do
  use ExUnit.Case
  doctest Parser


  test "Multi_digit" do
    ast= Lexer.lexing(File.read!("test/pruebas/multi_digit.c"))
    assert Parser.parse_program(ast) ==
      %AST{left_node:
        %AST{left_node:
          %AST{left_node:
            %AST{left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 100},
            node_name: :return,
            right_node: nil,
            value: :return},
          node_name: :function,
          right_node: nil,
          value: :main},
        node_name: :program,
        right_node: nil,
        value: nil}
  end

  test "newLines" do
    ast= Lexer.lexing(File.read!("test/pruebas/newlines.c"))
    assert Parser.parse_program(ast) ==
    %AST{left_node:
      %AST{left_node:
        %AST{left_node:
          %AST{left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 0},
          node_name: :return,
          right_node: nil,
          value: :return},
        node_name: :function,
        right_node: nil,
        value: :main},
      node_name: :program,
      right_node: nil,
      value: nil}
  end


  test "no newlines" do
    ast= Lexer.lexing(File.read!("test/pruebas/nonewlines.c"))
    assert Parser.parse_program(ast) ==
    %AST{left_node:
      %AST{left_node:
        %AST{left_node:
          %AST{left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 0},
          node_name: :return,
          right_node: nil,
          value: :return},
        node_name: :function,
        right_node: nil,
        value: :main},
      node_name: :program,
      right_node: nil,
      value: nil}
  end

  test "return 0" do
    ast= Lexer.lexing(File.read!("test/pruebas/return0.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node:
        %AST{left_node:
          %AST{left_node:
            %AST{left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0},
            node_name: :return,
          right_node: nil,
          value: :return},
        node_name: :function,
        right_node: nil,
        value: :main},
      node_name: :program,
      right_node: nil,
      value: nil}
  end

  test "return 2" do
    ast= Lexer.lexing(File.read!("test/pruebas/return2.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node:
        %AST{left_node:
          %AST{left_node:
            %AST{left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2},
            node_name: :return,
          right_node: nil,
          value: :return},
        node_name: :function,
        right_node: nil,
        value: :main},
      node_name: :program,
      right_node: nil,
      value: nil}
  end

  test "spaces" do
    ast= Lexer.lexing(File.read!("test/pruebas/spaces.c"))
    assert Parser.parse_program(ast) ==
    %AST{left_node:
      %AST{left_node:
        %AST{left_node:
          %AST{left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 0},
          node_name: :return,
          right_node: nil,
          value: :return},
        node_name: :function,
        right_node: nil,
        value: :main},
      node_name: :program,
      right_node: nil,
      value: nil}
  end


  test "Missing paren" do
    ast= Lexer.lexing(File.read!("test/pruebas/missing_paren.c"))
    assert Parser.parse_program(ast) ==  {:error, "ERROR AT 1: close parentesis missed "}

  end

  test "Missing return value" do
    ast= Lexer.lexing(File.read!("test/pruebas/missing_return.c"))
    assert Parser.parse_program(ast) ==  {:error, "ERROR AT 2: expect an int value"}
  end

  test "no brace" do
    ast= Lexer.lexing(File.read!("test/pruebas/no_brace.c"))
    assert Parser.parse_program(ast) == {:error, "ERROR AT 2: open brace missed "}
  end

  test "no semicolon" do
    ast= Lexer.lexing(File.read!("test/pruebas/no_semicolon.c"))
    assert Parser.parse_program(ast) == {:error, "ERROR AT 3: semicolon missed after constant to finish return statement "}
  end

  test "no space" do
    ast= Lexer.lexing(File.read!("test/pruebas/no_space.c"))
    assert Parser.parse_program(ast) == {:error, "ERROR AT 2: return keyword missed"}
  end

  test "Wrong Case" do
    ast= Lexer.lexing(File.read!("test/pruebas/wrong_case.c"))
    assert Parser.parse_program(ast) == {:error, "ERROR AT 2: return keyword missed"}

  end


end
