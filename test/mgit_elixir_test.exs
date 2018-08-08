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
end
