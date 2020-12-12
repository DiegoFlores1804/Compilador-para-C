defmodule Alphax do
  def main(args) do
    # Compiler options
    case args do
      # help
      ["-h"] ->
        IO.puts("Available options:\n
      -c <filename.c>  Compile program (check the same folder for [filename].exe).
      -t <filename.c>  Show token list.
      -a <filename.c>  Show AST.
      -s <filename.c>  Show assembler code.
      -o <filename.c>  [newName] | Compile the program with a new name.")

      # Token list
      ["-t", path] ->
            IO.puts("Token List: \n\n\n\n")
            # print token list
            IO.inspect(Lexer.lexing(File.read!(path)))

      # Print ast
      ["-a", path] ->
        IO.puts("Printing AST:\n\n\n\n")
        tokens = Lexer.lexing(File.read!(path))
        ast = Parser.parse_program(tokens)
        IO.inspect(ast)

      # Show Assebly code
      ["-s", path] ->
        IO.puts("Assembly code\n\n\n\n")
        tokens = Lexer.lexing(File.read!(path))
        ast = Parser.parse_program(tokens)
        assemblyCode = CodeGenerator.generate_code(ast)
        IO.puts(assemblyCode)


      # Full compile
      ["-c", path] ->
        IO.puts("Compiling the file: " <> path)
        tokens = Lexer.lexing(File.read!(path))
        ast = Parser.parse_program(tokens)
        assemblyCode = CodeGenerator.generate_code(ast)
        Linker.generate_binary(assemblyCode, path)


      # Full compile but with name change
      ["-o", path, newFilename] ->
        IO.puts(
          "Compiling the file:  " <>
            path <> " And renaming the executable to: " <> newFilename <> "\n\n\n\n"
        )


        tokens = Lexer.lexing(File.read!(path))
        ast = Parser.parse_program(tokens)
        assemblyCode = CodeGenerator.generate_code(ast)
        # do the full compiler route
        Linker.generate_new_binary(assemblyCode, path, newFilename)
      # but change the name (generate_binary (3))
      _ -> #The user input is wrong, show him some examples

        IO.puts("404 - NOT FOUND
        Please verify:
        1. PATH - must be on the same as the AlphaX files
        2. calling alphax correctly for example:
               ---> ./alphax -c <filename.c> (WITH .C EXTENSION; no brackets needed)
        Option list: ")
        IO.puts("Available options:\n
        -c <filename.c>  Compile program (check the same folder for [filename].exe).
        -t <filename.c>  Show token list.
        -a <filename.c>  Show AST.
        -s <filename.c>  Show assembler code.
        -o <filename.c>  [newName] | Compile the program with a new name.")
    end
  end
end
