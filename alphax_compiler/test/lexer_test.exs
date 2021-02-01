defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "pruebaTest" do
    ast = Lexer.lexing("int main() {
        return 100;
        }
        ")

    assert ast == [
             {:type, 1, [:intKeyWord]},
             {:ident, 1, [:mainKeyWord]},
             {:lParen, 1, []},
             {:rParen, 1, []},
             {:lBrace, 1, []},
             {:ident, 2, [:returnKeyWord]},
             {:num, 2, 100},
             {:semicolon, 2, []},
             {:rBrace, 3, []}
           ]
  end

  test "no Semicolon" do
    tlist = Lexer.lexing("int main(){
      return 100
    }")

    assert tlist ==
             [
               {:type, 1, [:intKeyWord]},
               {:ident, 1, [:mainKeyWord]},
               {:lParen, 1, []},
               {:rParen, 1, []},
               {:lBrace, 1, []},
               {:ident, 2, [:returnKeyWord]},
               {:num, 2, 100},
               {:rBrace, 3, []}
             ]
  end

  test "no constant" do
    tlist = Lexer.lexing("int main(){
      return ;
    }")

    assert tlist ==
             [
               {:type, 1, [:intKeyWord]},
               {:ident, 1, [:mainKeyWord]},
               {:lParen, 1, []},
               {:rParen, 1, []},
               {:lBrace, 1, []},
               {:ident, 2, [:returnKeyWord]},
               {:semicolon, 2, []},
               {:rBrace, 3, []}
             ]
  end

  test "wrong case" do
    tlist = Lexer.lexing("int main() {
      RETURN 0;
}")

    assert tlist ==
             [
               {:type, 1, [:intKeyWord]},
               {:ident, 1, [:mainKeyWord]},
               {:lParen, 1, []},
               {:rParen, 1, []},
               {:lBrace, 1, []},
               {:string, 2, ["RETURN"]},
               {:num, 2, 0},
               {:semicolon, 2, []},
               {:rBrace, 3, []}
             ]
  end

  test "random string" do
    tlist = Lexer.lexing("int main() {
                return asd;
        }")

    assert tlist == [
             {:type, 1, [:intKeyWord]},
             {:ident, 1, [:mainKeyWord]},
             {:lParen, 1, []},
             {:rParen, 1, []},
             {:lBrace, 1, []},
             {:ident, 2, [:returnKeyWord]},
             {:string, 2, ["asd"]},
             {:semicolon, 2, []},
             {:rBrace, 3, []}
           ]
  end

  test "garbage and unordered" do
    tlist = Lexer.lexing("writing a bunch of garbage
        unidintifiable tokens
        main ()
        perhaps a return here
        and finally a ;")

    assert tlist == [
             {:string, 1, ["writing"]},
             {:string, 1, ["a"]},
             {:string, 1, ["bunch"]},
             {:string, 1, ["of"]},
             {:string, 1, ["garbage"]},
             {:string, 2, ["unidintifiable"]},
             {:string, 2, ["tokens"]},
             {:ident, 3, [:mainKeyWord]},
             {:lParen, 3, []},
             {:rParen, 3, []},
             {:string, 4, ["perhaps"]},
             {:string, 4, ["a"]},
             {:ident, 4, [:returnKeyWord]},
             {:string, 4, ["here"]},
             {:string, 5, ["and"]},
             {:string, 5, ["finally"]},
             {:string, 5, ["a"]},
             {:semicolon, 5, []}
           ]
  end


  #Unary operators
  test "unary neg" do
    testList = Lexer.lexing(File.read!("test/pruebas/neg.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:negation]},
              {:num, 2, 5},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
            ]
  end

  test "unary bitw" do
    testList = Lexer.lexing(File.read!("test/pruebas/bitwise.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:bitW]},
              {:num, 2, 12},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
            ]
  end

  test "bitwise Zero" do
    testList = Lexer.lexing(File.read!("test/pruebas/bitwise_zero.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:bitW]},
              {:num, 2, 0},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
    ]
  end

  test "nested 1" do
    testList = Lexer.lexing(File.read!("test/pruebas/nested_ops.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:logicalN]},
              {:operator, 2, [:negation]},
              {:num, 2, 3},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
    ]
  end

  test "nested 2" do
    testList = Lexer.lexing(File.read!("test/pruebas/nested_ops_2.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:negation]},
              {:operator, 2, [:bitW]},
              {:num, 2, 0},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
    ]
  end

  test "not five" do
    testList = Lexer.lexing(File.read!("test/pruebas/not_five.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:logicalN]},
              {:num, 2, 5},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
            ]

  end

  test "not zero" do
    testList = Lexer.lexing(File.read!("test/pruebas/not_zero.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:logicalN]},
              {:num, 2, 0},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
            ]

  end

  test "missing const" do
    testList = Lexer.lexing(File.read!("test/pruebas/missing_const.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:logicalN]},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
            ]

  end

  test "missing semicolon" do
    testList = Lexer.lexing(File.read!("test/pruebas/missing_semicolon.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:logicalN]},
              {:num, 2, 5},
              {:rBrace, 3, []}
    ]
  end

  test "nested missing const" do
    testList = Lexer.lexing(File.read!("test/pruebas/nested_missing_const.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:logicalN]},
              {:operator, 2, [:bitW]},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
            ]
  end

  test "wrong order" do
    testList = Lexer.lexing(File.read!("test/pruebas/wrong_order.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 4},
              {:operator, 2,[:negation]},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
            ]
  end


end
