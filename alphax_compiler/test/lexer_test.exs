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

  #Binary operators

  test "add" do
    testList = Lexer.lexing(File.read!("test/pruebas/add.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 1},
              {:operator, 2, [:addition]},
              {:num, 2, 2},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
    ]
  end

  test "associativity" do
    testList = Lexer.lexing(File.read!("test/pruebas/associativity.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 1},
              {:operator, 2, [:negation]},
              {:num, 2, 2},
              {:operator, 2, [:negation]},
              {:num, 2, 3},
              {:semicolon, 2, []},
              {:rBrace, 3, []}

    ]
  end

  test "associativity 2" do
    testList = Lexer.lexing(File.read!("test/pruebas/associativity_2.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 6},
              {:operator, 2, [:division]},
              {:num, 2, 3},
              {:operator, 2, [:division]},
              {:num, 2, 2},
              {:semicolon, 2, []},
              {:rBrace, 3, []}

    ]
  end

  test "div" do
    testList = Lexer.lexing(File.read!("test/pruebas/div.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 4},
              {:operator, 2, [:division]},
              {:num, 2, 2},
              {:semicolon, 2, []},
              {:rBrace, 3, []}

    ]
  end

  test "div neg" do
    testList = Lexer.lexing(File.read!("test/pruebas/div_neg.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:lParen, 2, []},
              {:operator, 2, [:negation]},
              {:num, 2, 12},
              {:rParen, 2, []},
              {:operator, 2, [:division]},
              {:num, 2, 5},
              {:semicolon, 2, []},
              {:rBrace, 3, []}

    ]
  end

  test "mult" do
    testList = Lexer.lexing(File.read!("test/pruebas/mult.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 2},
              {:operator, 2, [:multiplication]},
              {:num, 2, 3},
              {:semicolon, 2, []},
              {:rBrace, 3, []}

    ]
  end

  test "parens" do
    testList = Lexer.lexing(File.read!("test/pruebas/parens.c"))
    assert testList == [

              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 2},
              {:operator, 2, [:multiplication]},
              {:lParen, 2, []},
              {:num, 2, 3},
              {:operator, 2, [:addition]},
              {:num, 2, 4},
              {:rParen, 2, []},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
    ]
  end

  test "precedence" do
    testList = Lexer.lexing(File.read!("test/pruebas/precedence.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 2},
              {:operator, 2, [:addition]},
              {:num, 2, 3},
              {:operator, 2, [:multiplication]},
              {:num, 2, 4},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
      ]
    end

  test "sub" do
    testList = Lexer.lexing(File.read!("test/pruebas/sub.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 1},
              {:operator, 2, [:negation]},
              {:num, 2, 2},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
      ]
    end

  test "sub_neg" do
    testList = Lexer.lexing(File.read!("test/pruebas/sub_neg.c"))
    assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 2},
              {:operator, 2, [:negation]},
              {:operator, 2, [:negation]},
              {:num, 2, 1},
              {:semicolon, 2, []},
              {:rBrace, 3, []}

      ]
    end

    test "unop add" do
      testList = Lexer.lexing(File.read!("test/pruebas/unop_add.c"))
      assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:bitW]},
              {:num, 2, 2},
              {:operator, 2, [:addition]},
              {:num, 2, 3},
              {:semicolon, 2, []},
              {:rBrace, 3, []}

        ]
      end

      test "unop parens" do
        testList = Lexer.lexing(File.read!("test/pruebas/unop_parens.c"))
        assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:bitW]},
              {:lParen, 2, []},
              {:num, 2, 1},
              {:operator, 2, [:addition]},
              {:num, 2, 1},
              {:rParen, 2, []},
              {:semicolon, 2, []},
              {:rBrace, 3, []}

          ]
        end

        #Binary operators (test to fail)

        test "malformed paren" do
        testList = Lexer.lexing(File.read!("test/pruebas/malformed_paren.c"))
        assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 2},
              {:lParen, 2, []},
              {:operator, 2, [:negation]},
              {:num, 2, 3},
              {:rParen, 2, []},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
        ]
      end

        test "No semicolon 2" do
          testList = Lexer.lexing(File.read!("test/pruebas/no_semicolon2.c "))
          assert testList ==[
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 2},
              {:operator, 2, [:multiplication]},
              {:num, 2, 2},
              {:rBrace, 3, []}

          ]
        end

        test "missing first operator" do
          testList = Lexer.lexing(File.read!("test/pruebas/missing_first_op.c"))
          assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:operator, 2, [:division]},
              {:num, 2, 3},
              {:semicolon, 2, []},
              {:rBrace, 3, []}

          ]
        end

        test "missing second op" do
          testList = Lexer.lexing(File.read!("test/pruebas/missing_second_op.c"))
          assert testList == [
              {:type, 1, [:intKeyWord]},
              {:ident, 1, [:mainKeyWord]},
              {:lParen, 1, []},
              {:rParen, 1, []},
              {:lBrace, 1, []},
              {:ident, 2, [:returnKeyWord]},
              {:num, 2, 1},
              {:operator, 2, [:addition]},
              {:semicolon, 2, []},
              {:rBrace, 3, []}
          ]
        end




end
