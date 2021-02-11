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
    assert Parser.parse_program(ast) ==  {:error, "ERROR AT 2: expected an int value"}
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

  #Unary operators (to pass)

  test "neg" do
    ast = Lexer.lexing(File.read!("test/pruebas/neg.c"))
    assert Parser.parse_program(ast) ==
    %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 5
              },
              node_name: :unary,
              right_node: nil,
              value: :negation
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
    }
  end

  test "bitW" do
    ast = Lexer.lexing(File.read!("test/pruebas/bitwise.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 12
            },
            node_name: :unary,
            right_node: nil,
            value: :bitW,
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "logicalNeg" do
    ast = Lexer.lexing(File.read!("test/pruebas/not_five.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 5
            },
            node_name: :unary,
            right_node: nil,
            value: :logicalN
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "not_zero" do
    ast = Lexer.lexing(File.read!("test/pruebas/not_zero.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0
            },
            node_name: :unary,
            right_node: nil,
            value: :logicalN
          },
          node_name: :return,
          right_node: nil,
          value: :return,
        },
        node_name: :function,
        right_node: nil,
        value: :main,
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "nested_operators" do
    ast = Lexer.lexing(File.read!("test/pruebas/nested_ops.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 3
              },
              node_name: :unary,
              right_node: nil,
              value: :negation
            },
            node_name: :unary,
            right_node: nil,
            value: :logicalN
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "nested_operators_2" do
    ast = Lexer.lexing(File.read!("test/pruebas/nested_ops_2.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              node_name: :unary,
              right_node: nil,
              value: :bitW
            },
            node_name: :unary,
            right_node: nil,
            value: :negation
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  #unary operators (test to fail)
  test "wrong_order" do
    ast = Lexer.lexing(File.read!("test/pruebas/wrong_order.c"))

    assert Parser.parse_program(ast) == {:error, "ERROR AT 2: expected an int value"}
  end

  test "semicolon_missed" do
    ast = Lexer.lexing(File.read!("test/pruebas/missing_semicolon.c"))
    assert Parser.parse_program(ast) == {:error, "ERROR AT 3: semicolon missed after constant to finish return statement "}
  end

  test "const_missed" do
    ast = Lexer.lexing(File.read!("test/pruebas/missing_const.c"))
    assert Parser.parse_program(ast) == {:error, "ERROR AT 2: expected an int value"}
  end
  test "constant_missed/nested_ops" do
    ast = Lexer.lexing(File.read!("test/pruebas/nested_missing_const.c"))
    assert Parser.parse_program(ast) == {:error, "ERROR AT 2: expected an int value"}
  end

  #Even more binary operators
  test "and false" do
    ast = Lexer.lexing(File.read!("test/pruebas/and_false.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              value: :logicalAND
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "and true" do
    ast = Lexer.lexing(File.read!("test/pruebas/and_true.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 1
                },
                node_name: :unary,
                right_node: nil,
                value: :negation
              },
              value: :logicalAND
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "eq false" do
    ast = Lexer.lexing(File.read!("test/pruebas/eq_false.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              value: :equalTo
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "eq true" do
    ast = Lexer.lexing(File.read!("test/pruebas/eq_true.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              value: :equalTo
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "ge false" do
    ast = Lexer.lexing(File.read!("test/pruebas/ge_false.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            value: :greaterThanOrEqualTo
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "ge true" do
    ast = Lexer.lexing(File.read!("test/pruebas/ge_true.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 1
            },
            value: :greaterThanOrEqualTo
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "gt false" do
    ast = Lexer.lexing(File.read!("test/pruebas/gt_false.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              value: :greaterThan
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "gt true" do
    ast = Lexer.lexing(File.read!("test/pruebas/gt_true.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              value: :greaterThan
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "le false" do
    ast = Lexer.lexing(File.read!("test/pruebas/le_false.c"))
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :unary,
              right_node: nil,
              value: :negation
            },
            value: :lessOrEqualTo
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "le true" do
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            value: :lessOrEqualTo
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }

  end

  test "lt false" do
    ast = Lexer.lexing(File.read!("test/pruebas/lt_false.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              value: :lessThan
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "lt true" do
    ast = Lexer.lexing(File.read!("test/pruebas/lt_true.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              value: :lessThan
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end




  test "or false" do
    ast = Lexer.lexing(File.read!("test/pruebas/or_false.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              value: :logicalOR
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "or true" do
    ast = Lexer.lexing(File.read!("test/pruebas/or_true.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              value: :logicalOR
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "precedence 1" do
    ast = Lexer.lexing(File.read!("test/pruebas/precedence1.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 0
                },
                node_name: :binary,
                right_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 2
                },
                value: :logicalAND
              },
              value: :logicalOR
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "precedence 2" do
    ast = Lexer.lexing(File.read!("test/pruebas/precedence_2.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 1
                },
                node_name: :binary,
                right_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 0
                },
                value: :logicalOR
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              value: :logicalAND
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "precedence 3" do
    ast = Lexer.lexing(File.read!("test/pruebas/precedence_3.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              node_name: :binary,
              right_node: %AST{
                left_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 2
                },
                node_name: :binary,
                right_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 0
                },
                value: :greaterThan
              },
              value: :equalTo
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "precedence 4" do
    ast = Lexer.lexing(File.read!("test/pruebas/precedence_4.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              node_name: :binary,
              right_node: %AST{
                left_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 2
                },
                node_name: :binary,
                right_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 0
                },
                value: :logicalOR
              },
              value: :equalTo
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "neg false" do
    ast = Lexer.lexing(File.read!("test/pruebas/ne_false.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              value: :nEqualTo
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end

  test "neg true" do
    ast = Lexer.lexing(File.read!("test/pruebas/ne_true.c"))
    assert Parser.parse_program(ast) ==
      %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: %AST{
                  left_node: nil,
                  node_name: :constant,
                  right_node: nil,
                  value: 1
                },
                node_name: :binary,
                right_node: %AST{
                  left_node: %AST{
                    left_node: nil,
                    node_name: :constant,
                    right_node: nil,
                    value: 2
                  },
                  node_name: :unary,
                  right_node: nil,
                  value: :negation
                },
                value: :nEqualTo
              },
              node_name: :unary,
              right_node: nil,
              value: :negation
            },
            node_name: :return,
            right_node: nil,
            value: :return
          },
          node_name: :function,
          right_node: nil,
          value: :main
        },
        node_name: :program,
        right_node: nil,
        value: nil
      }
  end


  #Even more binary operators (test to fail)

  test "missing_first_op1" do
    ast = Lexer.lexing(File.read!("test/pruebas/missing_first_op1.c"))

    assert Parser.parse_program(ast) == {:error, "***** ERROR 404 at 2: expect an unary operator"}
  end

  test "missing mid op" do
    ast = Lexer.lexing(File.read!("test/pruebas/missing_mid_op.c"))
    assert Parser.parse_program(ast) == {:error, "***** ERROR 404 at 2: expect an unary operator"}
  end

  test "missing second op2" do
    ast = Lexer.lexing(File.read!("test/pruebas/missing_second_op2.c"))
    assert Parser.parse_program(ast) == {:error, "ERROR AT 3: expected an int value"}
  end

  test "missing semicolon2" do
    ast = Lexer.lexing(File.read!("test/pruebas/missing_semicolon2.c"))
    assert Parser.parse_program(ast) == {:error, "ERROR AT 3: semicolon missed after constant to finish return statement "}
  end
end
