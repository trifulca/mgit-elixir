defmodule Parallel do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end

defmodule MgitElixir do
  alias TableRex.Table

  def main(_) do
    directorio = File.cwd!
    IO.puts("Consultando el directorio " <> directorio)
    imprimir(directorio)
  end

  def imprimir(path) do
    path |> repos |> MgitElixir.obtener_branchs_desde_lista_de_repositorios() |> imprimir_en_tabla
  end

  def imprimir_en_tabla([]) do
      IO.puts("No hay repositorios aquí")
  end

  def imprimir_en_tabla(lista_de_repositorios) do
    titulos = ["Repositorio", "Estado Remoto", "Estado Local", "Branch"]
    repositorios_como_lista = lista_de_repositorios |> convertir_a_array

    Table.new(repositorios_como_lista, titulos)
      |> Table.put_column_meta(1..7, color: fn(text, value) -> aplicar_color(text, value) end )
      |> Table.render!(header_separator_symbol: "-", top_frame_symbol: " ", bottom_frame_symbol: " ", horizontal_style: :header, vertical_style: :off)
      |> IO.puts
  end

  defp aplicar_color(texto, valor) do
    case valor do
      "↺ local" -> [:red, texto]
      "✓ local" -> [:green, texto]
      "↺ remoto" -> [:red, texto]
      "✓ remoto" -> [:green, texto]
      _ -> texto
    end
  end

  defp convertir_a_array(lista_de_repositorios) do
    lista_de_repositorios |> Enum.map(fn x -> [
        x[:nombre],
        convertir_en_texto(x[:remotos], "remoto"),
        convertir_en_texto(x[:locales], "local"),
        x[:branch]
      ] end)
  end

  def convertir_en_texto(cambios, texto) when cambios > 0 do
    "↺ " <> texto
  end

  def convertir_en_texto(cambios, texto) when cambios == 0 do
    "✓ " <> texto
  end

  def repos(path) do
    Path.wildcard(path <> "/*/.git", match_dot: true)
    |> Enum.map(fn x -> quitar_git(x) end)
  end

  def quitar_git(nombre) do
    String.replace(nombre, ".git", "")
  end

  def obtener_branchs_desde_lista_de_repositorios(repositorios) do
    repositorios |> Parallel.pmap(fn repo -> obtener_branch_y_repositorio(repo) end)
  end

  def branch(path) do
    git("rev-parse --abbrev-ref HEAD", path)
  end

  def obtener_branch_y_repositorio(path) do
    sincronizar(path)

    nombre_del_branch = branch(path)
    [
      repo: path,
      nombre: nombre(path),
      branch: nombre_del_branch,
      remotos: cantidad_de_cambios_remotos_no_sincronizados(path, nombre_del_branch),
      locales: obtener_cambios_sin_commits(path)
    ]
  end

  defp nombre(path) do
    Path.basename(path)
  end


  def sincronizar(path) do
    git("fetch origin", path)
    :ok
  end

  def realizar_pull(path, branch) do
    comando = "pull origin " <> branch
    git(comando, path)
  end

  def cantidad_de_cambios_remotos_no_sincronizados(path, branch) do
    comando = "rev-list HEAD...origin/" <> branch <> " --count"
    git(comando, path) |> String.to_integer()
  end

  def obtener_cambios_sin_commits(path) do
    cambios =
      git("status --short", path)
      |> String.trim()
      |> String.split("\n")
      |> Enum.count(fn item -> item != "" end)

    cambios
  end

  defp git(comando, path) do
    args = comando |> String.split()
    {output, 0} = System.cmd("git", args, cd: path, stderr_to_stdout: true)
    output |> String.trim()
  end
end
