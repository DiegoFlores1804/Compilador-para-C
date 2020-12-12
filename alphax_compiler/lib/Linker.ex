defmodule Linker do

  def generate_binary(assembler, assembly_path) do
    assembly_path = String.replace_trailing(assembly_path, ".c", ".s") #replaces .c extension with .s
    assembly_file_name = Path.basename(assembly_path)
    binary_file_name = Path.basename(assembly_path, ".s") #Get last file with .s extension (file was created in line 18)
    output_dir_name = Path.dirname(assembly_path)#get directory of .s file
    assembly_path = output_dir_name <> "/" <> assembly_file_name

    File.write!(assembly_path, assembler) #write assembler code in file.s
    System.cmd("gcc", [binary_file_name <> ".c", "-o#{binary_file_name}"], cd: output_dir_name) #gcc compile the file and create executable
    IO.puts("Assembly code Generated : #{assembly_path}") #Confirmation of the file generation
    IO.puts("Exectutable generated: #{output_dir_name}" <> "/" <> "#{binary_file_name}")
  end

  #receives as parameter assembler code and file name
  def generate_new_binary(assembler, file_path, name) do
    file_path = String.replace_trailing(file_path, ".c", ".s") #replaces .c extension with .s
    binary_file_name = Path.basename(file_path, ".s") #Get last file with .s extension (file was created in line 18)
    output_dir_name = Path.dirname(file_path)#get directory of .s file
    file_path = output_dir_name <> "/" <> name <> ".s"
    IO.inspect(file_path)

    File.write!(file_path, assembler) #write assembler code in file.s
    System.cmd("gcc", [binary_file_name <> ".c", "-o#{name}"], cd: output_dir_name)#gcc compile the file and create executable
    IO.puts("Assembly generated : #{file_path}") #Confirmation of the file generation
    IO.puts("Executable generated : #{output_dir_name}" <> "/" <> "#{name}")

  end
end
