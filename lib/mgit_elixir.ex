defmodule MgitElixir do
  def main(args) do
    IO.puts("Gola!")
  end

  def repos(path) do
    Path.wildcard(path <> "/*/.git", match_dot: true)
    |> Enum.map(fn x -> quitar_git(x) end)
  end

  def quitar_git(nombre) do
    String.replace(nombre, ".git", "")
  end

  def branch(path) do
    :pepe

    def branch(path):
    return ejecutar('git rev-parse --abbrev-ref HEAD', path)
  end
end
