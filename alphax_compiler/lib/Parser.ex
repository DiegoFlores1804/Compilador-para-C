defmodule Parser do

  def parse_program(tokenList) do
    newTokens = next(tokenList) #Get next token
    tokenListF = List.delete_at(tokenList, 0) #Delete first element of list
    result = parse_function(newTokens, tokenListF) #find newToken in tokenListF

    case result do
      {{:error, error_message}, tokenListF} -> #If result have an error
        {{:error, error_message}, tokenListF}
        {:error, error_message}

      {function_node, tokenListF} -> #{AST, tokenlist}
        if tokenListF == [] do #check if the tuple is empty
          %AST{node_name: :program, left_node: function_node} #Add the root in AST (program)
        else
          {:error, "Error: there are more elements after function end"}
        end
    end
  end

  # Function to get the next token
    def next(tokenListF) do
    element = Tuple.to_list(hd(tokenListF)) #get hd, it is converted to a list
    newTokens = List.first(element) #Get token

    if newTokens == :ident || newTokens == :type do #is a identificator or a data type?
      if newTokens == :num do
        List.last(element)
      else
        element = Tuple.to_list(hd(tokenListF)) #Get next element (same as line 24)
        List.last(List.last(element)) #Get value (it could be "int" or "main")
      end
    else
      element = Tuple.to_list(hd(tokenListF))  #Same that as line 24
      List.first(element) #Returning the keyword
    end
  end

  #How to know number line
  def line(tokenListF) do
    element = Tuple.to_list(hd(tokenListF)) #Get first element in the tuple and convert it in a list
    cola = tl(element) #get tail
    List.first(cola) #get value
  end


  #look for each token in the list.
  def parse_function(nextToken, tokenListF) do
    if nextToken == :intKeyWord do #fid intkeyword
      nextToken = next(tokenListF)

      if nextToken == :mainKeyWord do #find mainkeyword
        tokenListF = List.delete_at(tokenListF, 0)
        nextToken = next(tokenListF)

        if nextToken == :lParen do #find open parentesis
          tokenListF = List.delete_at(tokenListF, 0)
          nextToken = next(tokenListF)

          if nextToken == :rParen do #Find close parentesis
            tokenListF = List.delete_at(tokenListF, 0)
            nextToken = next(tokenListF)

            if nextToken == :lBrace do #Find open Brace
              tokenListF = List.delete_at(tokenListF, 0)
              nextToken = next(tokenListF)
              statement = parse_statement(nextToken, tokenListF)

              case statement do
                {{:error, error_message}, tokenListF} -> #Throws the error to the level up
                  {{:error, error_message}, tokenListF}

                {statement, tokenListF} ->
                  tokenListF = List.delete_at(tokenListF, 0)
                  nextToken = next(tokenListF)

                  if nextToken == :rBrace do #find close brace
                    tokenListF = List.delete_at(tokenListF, 0)
                    {%AST{node_name: :function, value: :main, left_node: statement}, tokenListF} #add new node in AST (function)
                  else
                    line = line(tokenListF)
                    {{:error, "ERROR AT #{line}: close brace missed "}, tokenListF}
                  end

              end
            else
              line = line(tokenListF)
              {{:error, "ERROR AT #{line}: open brace missed "}, tokenListF}
            end
          else
            line = line(tokenListF)
            {{:error, "ERROR AT #{line}: close parentesis missed "}, tokenListF}
          end
        else
          line = line(tokenListF)
          {{:error, "ERROR AT #{line}: open parentesis missed "}, tokenListF}
        end
      else
        line = line(tokenListF)
        {{:error, "ERROR AT #{line}: main function missed "}, tokenListF}
      end
    else
      line = line(tokenListF)
      {{:error, "ERROR AT #{line}: return type value missed "}, tokenListF}
    end
  end


  # look for returnkeyword and semicolon
  def parse_statement(nextToken, tokenListF) do
    if nextToken == :returnKeyWord do   #Find returnkeyword
      tokenListF = List.delete_at(tokenListF, 0)
      expression= parse_expression(tokenListF)
      case expression do
        {{:error, error_message}, tokenListF} ->
          {{:error, error_message}, tokenListF}

        {expression, tokenListF} ->
          nextToken = next(tokenListF)

          if nextToken == :semicolon do #Find semicolon
            {%AST{node_name: :return, value: :return, left_node: expression}, tokenListF} #add new node in AST (return)
          else
            line = line(tokenListF)
            {{:error, "ERROR AT #{line}: semicolon missed after constant to finish return statement "},
             tokenListF}
          end
      end
    else
      line = line(tokenListF)
      {{:error, "ERROR AT #{line}: return keyword missed"}, tokenListF}
    end
  end


   #Only verify a constant expression
   def parse_expression(tokenListF) do
    nextToken = next(tokenListF) #take next token in the tuple(expected constant)
    element = Tuple.to_list(hd(tokenListF)) #Converted token in list
    newTokens = List.last(element) #take last element in list
    case {nextToken, newTokens} do
      {{:error, error_message}, tokenListF} ->
        {{:error, error_message}, tokenListF}

      {:num, numero} -> #Find constant
        tokenListF = List.delete_at(tokenListF, 0)
        {%AST{node_name: :constant, value: numero}, tokenListF} #add new node in AST (constant)

      _ ->
        line = line(tokenListF)
        {{:error, "ERROR AT #{line}: expect an int value"}, tokenListF}
    end


  end


end
