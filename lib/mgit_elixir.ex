defmodule MgitElixir do
  def main(_) do
    imprimir(System.cwd!())
  end

  def imprimir(path) do
    path |> repos |> IO.puts()
  end

  def repos(path) do
    Path.wildcard(path <> "/*/.git", match_dot: true)
    |> Enum.map(fn x -> quitar_git(x) end)
  end

  def quitar_git(nombre) do
    String.replace(nombre, ".git", "")
  end

  def branch(path) do
    git("rev-parse --abbrev-ref HEAD", path)
  end

  def sincronizar(path) do
    git("fetch origin", path)
    :ok
  end

  defp git(comando, path) do
    args = comando |> String.split()
    {output, 0} = System.cmd("git", args, cd: path)
    output |> String.trim()
  end
end
