defmodule MgitElixirTest do
  use ExUnit.Case
  doctest MgitElixir

  test "puede quitar .git" do
    assert MgitElixir.quitar_git("mi_repo/.git") == "mi_repo/"
  end

  test "puede listar repositorios del fixture" do
    assert MgitElixir.repos("fixture") |> Enum.count() == 1
  end

  test "puede listar repos y no tiene .git al final" do
    assert is_list(MgitElixir.repos("/proyectos"))

    assert MgitElixir.repos("/proyectos") |> Enum.find(fn x -> String.ends_with?(x, ".git") end) ==
             nil
  end

  test "Puede listar e imprimir fixtures" do
    assert MgitElixir.branch("fixture/mgit_elixir") == "master"
  end

  test "Puede sincronizar los fixtures" do
    assert MgitElixir.sincronizar("fixture/mgit_elixir") == :ok
  end

  test "Puede listar el estado del fixture en consola" do
    MgitElixir.imprimir("fixture/")
  end

  test "Puede obtener los cambios remotos" do
    repo = "fixture/mgit_elixir"
    branch = "master"
    MgitElixir.sincronizar(repo)
    MgitElixir.realizar_pull(repo, branch)
    assert MgitElixir.cantidad_de_cambios_remotos_no_sincronizados(repo, branch) == 0
  end

  test "Puede obtener el repositorio junto con el branch" do
    assert MgitElixir.obtener_branch_y_repositorio("fixture/mgit_elixir") == [
             repo: "fixture/mgit_elixir",
             branch: "master",
             remotos: 0,
             locales: 0
           ]
  end

  test "Puede obtener el repositorio junto con el branch de una lista" do
    lista = ["fixture/mgit_elixir"]

    assert MgitElixir.obtener_branchs_desde_lista_de_repositorios(lista) == [
             [repo: "fixture/mgit_elixir", branch: "master", remotos: 0, locales: 0]
           ]
  end
end
