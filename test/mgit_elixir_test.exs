defmodule MgitElixirTest do
  use ExUnit.Case
  doctest MgitElixir

  test "greets the world" do
    assert MgitElixir.hello() == :world
  end

  test "puede quitar .git" do
    assert MgitElixir.quitar_git("mi_repo/.git") == "mi_repo/"
  end

  test "puede listar repos" do
    assert MgitElixir.repos("/proyectos") |> Enum.count() > 0
  end

  test "puede listar repos y no tiene .git al final" do
    assert is_list(MgitElixir.repos("/proyectos"))

    assert MgitElixir.repos("/proyectos") |> Enum.find(fn x -> String.ends_with?(x, ".git") end) ==
             nil
  end
end
