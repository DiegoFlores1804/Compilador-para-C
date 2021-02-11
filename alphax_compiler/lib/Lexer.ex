defmodule Lexer do
  def lexer(lexicon, column) do

    tokenList = [
      {:type, :intKeyWord},
      {:ident, :returnKeyWord},
      {:ident, :mainKeyWord},
      {:lBrace},
      {:rBrace},
      {:lParen},
      {:rParen},
      {:semicolon},
      #Second Delivery
      {:operator, :negation},
      {:operator, :logicalN},
      {:operator, :bitW},
      #Thrid Delivery
      {:operator, :multiplication},
      {:operator, :addition},
      {:operator, :division},
      #Fourth Delivery
      {:operator, :logicalAND},
      {:operator, :logicalOR},
      {:operator, :equalTo},
      {:operator, :nEqualTo},
      {:operator, :lessThan},
      {:operator, :lessOrEqualTo},
      {:operator, :greaterThan},
      {:operator, :greaterThanOrEqualTo}
      ]
    # Token list to be mapped and compared to the file .c token to the keywords list
    convKey = fn a -> {tokenToStr(a), a} end
    newkeywords=Enum.map(tokenList,convKey) #new token list with strings (string before token)

    #Regular expressions for spaces, newlines, letters, numbers.
    spaces = ~r(^[ \h]+) #All spaces
    newLine = ~r(^[\r\n]\n*) #All newlines
    alpha = ~r{(^[a-zA-Z]\w*)|(\|\|)} #All characters
    numb = ~r(^[0-9]+) #All numbers


    cond do
      lexicon == "" ->
        []

      Regex.match?(spaces, lexicon) -> #return Boolean, find spaces.
        lexer(Regex.replace(spaces, lexicon, "", global: false), column) #replace it with nothing

      Regex.match?(newLine, lexicon) -> #find newline
        lexer(Regex.replace(newLine, lexicon, "", global: false), column + 1) #Column number increases for every newline

      Regex.match?(numb, lexicon) -> #find numbers
        num = String.to_integer(List.first(Regex.run(numb, lexicon))) #find all numbers, return first element in the list, finally it´s converted in an integer
        [
          {:num, column, num}                                              #save column and number.
          | lexer(Regex.replace(numb, lexicon, "", global: false), column) #replace numb with nothing
        ]

      true ->
        {result, tokenStr} = serchKeyw(lexicon, newkeywords) #comparate file.c without spaces, newlines, etc. vs tokens with string.

        cond do
          #for print existing tokens and column
          result ->
            case tokenStr do #{string, {:type, :keyword}}
              {str, {a, b}} ->
                [{a, column, [b]} | lexer(String.replace_leading(lexicon, str, ""), column)] # list for show words int, main, etc.

              {str, {a}} ->
                [
                  {a, column, []}
                  | lexer(String.replace_leading(lexicon, str, ""), column) # list for show characters (), {}, etc.
                ]
            end

          # If there's no match

          Regex.match?(alpha, lexicon) -> #if exist characters of alphabet
            iden = List.first(Regex.run(alpha, lexicon, [{:capture, :first}])) #return matches of alpha
            token = {:string, column, [iden]} #this is saved as a new token
            [token | lexer(Regex.replace(alpha, lexicon, "", global: false), column)] #list for show string as a token.

          true -> #otherwise, if theres an unrecognaziable character:
            raise "ERROR AT  " <>"#{lexicon}" <> "ON COLUMN LINE  "  <> "#{column}"
        end
    end
  end


  def lexing(lexicon) do

    column = 1
    # In each newLine a new track starts to tell you if compiler finds an non belonging char
    lexer(lexicon, column) #first parameter is file content, second parameter is column number
  end

  #Each token is represented by a string
  def tokenToStr(token) do
    case token do
      {:number, number} ->
        to_string(number)      #Numbers are coverted
      {:string, str} ->
        str                    #Strings no need convert, they are return
      {:type, :intKeyWord} ->
        "int "                 # it is an int
      {:ident, :returnKeyWord} ->
        "return "             #  return
      {:ident, :mainKeyWord} ->
        "main"                 #  main
      {:lBrace} ->             # Syntax characters
         "{"
      {:rBrace} ->
         "}"
      {:lParen} ->
         "("
      {:rParen} ->
         ")"
      {:semicolon} ->
        ";"
      #Second - Delivery (unary operators)
      {:operator, :negation} ->
        "-"
      {:operator, :logicalN} ->
        "! "
      {:operator, :bitW} ->
        "~"

      #Third - Delivery (binary operators)
      {:operator, :multiplication} ->
        "*"
      {:operator, :addition} ->
        "+"
      {:operator, :division} ->
        "/"

      #Fourth - Delivery (even more binary operators)
      {:operator, :logicalAND} ->
        "&&"
      {:operator, :logicalOR} ->
        "||"
      {:operator, :equalTo} ->
        "=="
      {:operator, :nEqualTo} ->
        "!="
      {:operator, :lessThan} ->
        "< "
      {:operator, :lessOrEqualTo} ->
        "<="
      {:operator, :greaterThan} ->
        "> "
      {:operator, :greaterThanOrEqualTo} ->
        ">="
    end
  end

  def serchKeyw(input, newkeywords) do

    Enum.reduce_while(newkeywords, {}, fn {key, val}, _ -> #check until the collection ends,
      if !String.starts_with?(input, key) do   #Return true if file.c (input) starts with string int, main, etc. (key)
        {:cont, {false, {}}}  #continue iterating
      else
        {:halt, {true, {key, val}}}   #end of collection
       #key is string, val is token
      end
    end)
  end
end
