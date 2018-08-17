defmodule MgitElixir do
  def main(_) do
    imprimir(System.cwd!())
  end

  def imprimir(path) do
    path |> repos |> MgitElixir.obtener_branchs_desde_lista_de_repositorios()
  end

  def repos(path) do
    Path.wildcard(path <> "/*/.git", match_dot: true)
    |> Enum.map(fn x -> quitar_git(x) end)
  end

  def quitar_git(nombre) do
    String.replace(nombre, ".git", "")
  end

  def obtener_branchs_desde_lista_de_repositorios(repositorios) do
    repositorios |> Enum.map(fn repo -> obtener_branch_y_repositorio(repo) end)
  end

  def branch(path) do
    git("rev-parse --abbrev-ref HEAD", path)
  end

  def obtener_branch_y_repositorio(path) do
    nombre_del_branch = branch(path)

    [
      repo: path,
      branch: nombre_del_branch,
      remotos: cantidad_de_cambios_remotos_no_sincronizados(path, nombre_del_branch),
      locales: obtener_cambios_sin_commits(path)
    ]
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
      |> Enum.count()

    cambios - 1
  end

  defp git(comando, path) do
    args = comando |> String.split()
    {output, 0} = System.cmd("git", args, cd: path, stderr_to_stdout: true)
    output |> String.trim()
  end
end
